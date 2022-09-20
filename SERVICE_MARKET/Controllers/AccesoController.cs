using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SERVICE_MARKET.Models;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Data;

namespace SERVICE_MARKET.Controllers
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
        public ActionResult Registrar(Usuario oUsuario)
        {
            bool registrado;
            string mensaje;
            
            /*COMPARANDO CONTRASEÑAS*/
            if (oUsuario.CONTRASENA == oUsuario.CONFIRMAR_CONTRASENA)
            {
                /*ENCRIPTANDO CONTRASEÑA*/
                oUsuario.CONTRASENA = ConvertirSha256(oUsuario.CONTRASENA);
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
                cmd.Parameters.AddWithValue("IDENTIFICACION_U", oUsuario.IDENTIFICACION_U);
                cmd.Parameters.AddWithValue("TIPO_DOC", oUsuario.TIPO_DOC);
                cmd.Parameters.AddWithValue("NOMBRE", oUsuario.NOMBRE.ToUpper());
                cmd.Parameters.AddWithValue("APELLIDOS", oUsuario.APELLIDOS.ToUpper());
                cmd.Parameters.AddWithValue("CELULAR", oUsuario.CELULAR);
                cmd.Parameters.AddWithValue("CORREO_ELECTRONICO", oUsuario.CORREO_ELECTRONICO.ToUpper());
                cmd.Parameters.AddWithValue("CONTRASENA", oUsuario.CONTRASENA);
                cmd.Parameters.AddWithValue("FECHA_NACIMIENTO", oUsuario.FECHA_NACIMIENTO);
                cmd.Parameters.AddWithValue("ID_ROL_FK", oUsuario.ID_ROL_FK);
                cmd.Parameters.Add("REGISTRADO", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("MENSAJE", SqlDbType.VarChar,100).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                cmd.ExecuteNonQuery();
                registrado = Convert.ToBoolean(cmd.Parameters["REGISTRADO"].Value);
                mensaje = cmd.Parameters["MENSAJE"].Value.ToString();
            }

            ViewData["MENSAJE"] = mensaje;

            if (registrado)
            {
                return RedirectToAction("Login", "Acceso");
            }else
            {
                return View();
            }
        }

        /*METODO INICIAR SESION*/
        [HttpPost]
        public ActionResult Login(Usuario oUsuario)
        {
            /*ENCRIPTANDO CONTRASEÑA*/
            oUsuario.CONTRASENA = ConvertirSha256(oUsuario.CONTRASENA);

            /*CONECTANDO BASE DE DATOS*/
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                /*PROCEDIMIENTO ALMACENADO VALIDAR USUARIO*/
                SqlCommand cmd = new SqlCommand("VALIDAR_USUARIO", cn);
                cmd.Parameters.AddWithValue("CORREO_ELECTRONICO", oUsuario.CORREO_ELECTRONICO);
                cmd.Parameters.AddWithValue("CONTRASENA", oUsuario.CONTRASENA);
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                oUsuario.ID_USUARIO = Convert.ToInt32(cmd.ExecuteScalar().ToString());

                /*LEER LOS ATRIBUTOS DEL OBJETO USUARIO*/
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        oUsuario = new Usuario()
                        {
                            IDENTIFICACION_U = dr["IDENTIFICACION_U"].ToString(),
                            NOMBRE = dr["NOMBRE"].ToString(),
                            APELLIDOS = dr["APELLIDOS"].ToString(),
                            CELULAR = dr["CELULAR"].ToString(),
                            CORREO_ELECTRONICO = dr["CORREO_ELECTRONICO"].ToString(),
                            CONTRASENA = dr["CONTRASENA"].ToString(),
                            ID_ROL_FK = (Rol)dr["ID_ROL_fK"],
                        };
                    }
                }
            }
            
            if (oUsuario.ID_ROL_FK == Rol.ADMINISTRADOR)
            {
                Session["Usuario"] = oUsuario;
                return RedirectToAction("Index", "Home");
            }else
            {
                ViewData["MENSAJE"] = "Usuario no encontrado";
                return View();
            }      
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