using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace SERVICE_MARKET.Models
{
    public class MantenimientoServicios
    {
        /*CADENA DE CONEXION*/
        static string cadena = "Data Source=LAPTOP-RMAAM810;Initial Catalog=SERVICE_MARKET;Integrated Security=True";

        public int CrearPublicacion(Servicios oServicios)
        {
            /*CONECTANDO BASE DE DATOS*/
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                /*PROCEDIMIENTO ALMACENADO CREAR SERVICIOS*/
                SqlCommand cmd = new SqlCommand("CREAR_SERVICIOS", cn);
                cmd.Parameters.AddWithValue("IMAGEN", oServicios.IMAGEN);
                cmd.Parameters.AddWithValue("NOMBRE", oServicios.NOMBRE);
                cmd.Parameters.AddWithValue("PRECIO", oServicios.PRECIO);
                cmd.Parameters.AddWithValue("TERMINOS", oServicios.TERMINOS);
                cmd.Parameters.AddWithValue("ID_CATEGORIA_FK", oServicios.ID_CATEGORIA_FK);
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }

        /*LEER REGISTROS DE SERVICIOS*/
        public List<Servicios> RecuperarTodos()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                List<Servicios> servicios = new List<Servicios>();
                SqlCommand cmd = new SqlCommand("CONSULTAR_SERVICIOS", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                SqlDataReader registros = cmd.ExecuteReader();
                while (registros.Read())
                {
                    Servicios serv = new Servicios
                    {
                        IMAGEN = registros["IMAGEN"].ToString(),
                        NOMBRE = registros["NOMBRE"].ToString(),
                        PRECIO = Decimal.Parse(registros["PRECIO"].ToString()),
                        TERMINOS = registros["TERMINOS"].ToString(),
                        ID_CATEGORIA_FK = int.Parse(registros["ID_CATEGORIA_FK"].ToString()),
                        NOMBRE_CAT = registros["NOMBRE_CAT"].ToString()
                    };
                    servicios.Add(serv);
                }
                return servicios;
            }

        }
    }
}