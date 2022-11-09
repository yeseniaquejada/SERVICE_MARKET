using Service_market_.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Service_market_.Controllers
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
        public ActionResult Registrar(Usuario oUsuarios)
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
                cmd.Parameters.AddWithValue("TIPO_DOC", oUsuarios.TIPO_DOC);
                cmd.Parameters.AddWithValue("N_IDENTIFICACION", oUsuarios.N_IDENTIFICACION);
                cmd.Parameters.AddWithValue("FECHA_NACIMIENTO", oUsuarios.FECHA_NACIMIENTO);
                cmd.Parameters.AddWithValue("FECHA_EXPEDICION", oUsuarios.FECHA_EXPEDICION);
                cmd.Parameters.AddWithValue("NOMBRE_USU", oUsuarios.NOMBRE_USU.ToUpper());
                cmd.Parameters.AddWithValue("APELLIDOS_USU", oUsuarios.APELLIDOS_USU.ToUpper());
                cmd.Parameters.AddWithValue("CELULAR_USU", oUsuarios.CELULAR_USU);
                cmd.Parameters.AddWithValue("GENERO", oUsuarios.GENERO);
                cmd.Parameters.AddWithValue("ID_CIUDAD_FK", oUsuarios.ID_CIUDAD_FK);
                cmd.Parameters.AddWithValue("DIRECCION", oUsuarios.DIRECCION.ToUpper());
                cmd.Parameters.AddWithValue("CORREO_ELECTRONICO", oUsuarios.CORREO_ELECTRONICO.ToUpper());
                cmd.Parameters.AddWithValue("CONTRASENA", oUsuarios.CONTRASENA);
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
        public ActionResult Login(Usuario oUsuarios)
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

                /*LEER IDENTIFICACION DEL USUARIO (PRIMERA FILA)*/
                oUsuarios.N_IDENTIFICACION = cmd.ExecuteScalar().ToString();
            }

            /*ACCESO A VISTAS*/
            if (oUsuarios.N_IDENTIFICACION != "0")
            {
                Session["Usuario"] = oUsuarios;
                return RedirectToAction("ServiciosConsultar", "Servicios");
            }
            else
            {
                ViewData["MENSAJE"] = "Usuario no encontrado";
            }
            return View();
        }

        /*METODO PARA CERRAR SESION*/
        public ActionResult CerrarSesion()
        {
            Session["Usuario"] = null;
            return RedirectToAction("Index", "Home");
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