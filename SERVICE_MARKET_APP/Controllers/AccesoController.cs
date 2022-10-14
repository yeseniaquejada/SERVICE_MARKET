using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using SERVICE_MARKET_APP.Models;

namespace SERVICE_MARKET_APP.Controllers
{
    public class AccesoController : Controller
    {
        /*CADENA DE CONEXION*/
        static string cadena = "Data Source=LAPTOP-RMAAM810;Initial Catalog=SERVICE_MARKET;Integrated Security=True";

        // GET: Acceso
        public ActionResult Login()
        {
            return View();
        }

        public ActionResult Registrar()
        {
            return View();
        }

        /*METODO REGISTRAR*/
        [HttpPost]
        public ActionResult Registrar(Usuarios oUsuarios)
        {
            bool registrado;
            string mensaje;

            /*COMPARANDO CONTRASEÑAS*/
            if (oUsuarios.CONTRASENA == oUsuarios.CONFIRMAR_CONTRASENA)
            {
                /*ENCRIPTANDO CONTRASEÑA*/
                oUsuarios.CONTRASENA = ConvertirSha256(oUsuarios.CONTRASENA);
            }
            else
            {
                ViewData["MENSAJE"] = "Las contraseñas no coinciden";
                return View();
            }

            /*CONECTANDO BASE DE DATOS*/
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                /*PROCEDIMIENTO ALMACENADO REGISTRAR USUARIO*/
                SqlCommand cmd = new SqlCommand("REGISTRAR_USUARIO", cn);
                cmd.Parameters.AddWithValue("IDENTIFICACION_U", oUsuarios.IDENTIFICACION_U);
                cmd.Parameters.AddWithValue("TIPO_DOC", oUsuarios.TIPO_DOC);
                cmd.Parameters.AddWithValue("NOMBRE", oUsuarios.NOMBRE.ToUpper());
                cmd.Parameters.AddWithValue("APELLIDOS", oUsuarios.APELLIDOS.ToUpper());
                cmd.Parameters.AddWithValue("CELULAR", oUsuarios.CELULAR);
                cmd.Parameters.AddWithValue("CORREO_ELECTRONICO", oUsuarios.CORREO_ELECTRONICO.ToUpper());
                cmd.Parameters.AddWithValue("CONTRASENA", oUsuarios.CONTRASENA);
                cmd.Parameters.AddWithValue("FECHA_NACIMIENTO", oUsuarios.FECHA_NACIMIENTO);
                cmd.Parameters.AddWithValue("ID_ROL_FK", oUsuarios.ID_ROL_FK);
                cmd.Parameters.Add("REGISTRADO", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("MENSAJE", SqlDbType.VarChar, 100).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                cmd.ExecuteNonQuery();

                /*LEER PARAMETROS DE SALIDA*/
                registrado = Convert.ToBoolean(cmd.Parameters["REGISTRADO"].Value);
                mensaje = cmd.Parameters["MENSAJE"].Value.ToString();
            }
            

            ViewData["MENSAJE"] = mensaje;

            if (registrado)
            {
                return RedirectToAction("Login", "Acceso");
            }
            else
            {
                return View();
            }
        }

        /*METODO INICIAR SESION*/
        [HttpPost]
        public ActionResult Login(Usuarios oUsuarios)
        {
            /*ENCRIPTANDO CONTRASEÑA*/
            oUsuarios.CONTRASENA = ConvertirSha256(oUsuarios.CONTRASENA);

            /*CONECTANDO BASE DE DATOS*/
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                /*PROCEDIMIENTO ALMACENADO VALIDAR USUARIO*/
                SqlCommand cmd = new SqlCommand("VALIDAR_USUARIO", cn);
                cmd.Parameters.AddWithValue("CORREO_ELECTRONICO", oUsuarios.CORREO_ELECTRONICO);
                cmd.Parameters.AddWithValue("CONTRASENA", oUsuarios.CONTRASENA);
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();

                /*LEER ID DEL USUARIO (PRIMERA FILA)*/
                oUsuarios.ID_USUARIO = Convert.ToInt32(cmd.ExecuteScalar().ToString());

                /*LEER ATRIBUTOS DEL OBJETO USUARIO*/
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        oUsuarios = new Usuarios()
                        {
                            IDENTIFICACION_U = dr["IDENTIFICACION_U"].ToString(),
                            TIPO_DOC = dr["TIPO_DOC"].ToString(),
                            NOMBRE = dr["NOMBRE"].ToString(),
                            APELLIDOS = dr["APELLIDOS"].ToString(),
                            CELULAR = dr["CELULAR"].ToString(),
                            CORREO_ELECTRONICO = dr["CORREO_ELECTRONICO"].ToString(),
                            CONTRASENA = dr["CONTRASENA"].ToString(),
                            ID_ROL_FK = (Roles)dr["ID_ROL_fK"],
                        };
                    }
                }
            }

            /*ACCESO A VISTAS SEGUN ROL*/
            if (oUsuarios.ID_USUARIO != 0)
            {
                if (oUsuarios.ID_ROL_FK == Roles.ADMINISTRADOR)
                {
                    Session["Usuario"] = oUsuarios;
                    return RedirectToAction("IndexAdministrador", "Administrador");
                }
                else if (oUsuarios.ID_ROL_FK == Roles.PROVEEDOR)
                {
                    Session["Usuario"] = oUsuarios;
                    return RedirectToAction("IndexProveedor", "Proveedor");
                }
                else if (oUsuarios.ID_ROL_FK == Roles.CLIENTE)
                {
                    Session["Usuario"] = oUsuarios;
                    return RedirectToAction("IndexCliente", "Cliente");
                }
            }
            else
            {
                ViewData["MENSAJE"] = "Usuario no encontrado";
            }
            return View();
        }

        /*METODO ENCRIPTAR CONTRASEÑA*/
        public static string ConvertirSha256(string texto)
        {
            StringBuilder Sb = new StringBuilder();
            using (SHA256 hash = SHA256Managed.Create())
            {
                Encoding enc = Encoding.UTF8;
                byte[] result = hash.ComputeHash(enc.GetBytes(texto));
                foreach (byte b in result)
                    Sb.Append(b.ToString("x2"));
            }
            return Sb.ToString();
        }
    }
}