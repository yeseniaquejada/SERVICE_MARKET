using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace _SERVICE_MARKET_.Models
{
    public class MantenimientoServicios
    {
        /*CADENA DE CONEXION*/
        IDbConnection cadena = DbCommon.Conexion();

        //METODO PARA AGREGAR SERVICIOS
        public int AgregarServicio(Servicio oServicios)
        {
            cadena.Open();
            SqlCommand Comand = new SqlCommand("CREAR_SERVICIOS", cadena as SqlConnection);
            Comand.CommandType = CommandType.StoredProcedure;
            Comand.Parameters.Add(new SqlParameter("@IMAGEN_SER", oServicios.IMAGEN_SER));
            Comand.Parameters.Add(new SqlParameter("@NOMBRE_SER", oServicios.NOMBRE_SER));
            Comand.Parameters.Add(new SqlParameter("@PRECIO_SER", oServicios.PRECIO_SER));
            Comand.Parameters.Add(new SqlParameter("@TERMINOS_SER", oServicios.TERMINOS_SER));
            Comand.Parameters.Add(new SqlParameter("@ID_CATEGORIA_FK", oServicios.ID_CATEGORIA_FK));
            int Publicacion = Comand.ExecuteNonQuery();
            cadena.Close();
            return Publicacion;
        }

        //METODO PARA CONSULTAR SERVICIOS
        public List<Servicio> ConsultarServicios()
        {
            cadena.Open();
            List<Servicio> lista = new List<Servicio>();
            SqlCommand Comand = new SqlCommand("CONSULTAR_SERVICIOS", cadena as SqlConnection);
            Comand.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = Comand.ExecuteReader();
            
            while (reader.Read())
            {
                Servicio oServicios = new Servicio
                {
                    IMAGEN_SER = reader["IMAGEN_SER"].ToString(),
                    NOMBRE_SER = reader["NOMBRE_SER"].ToString(),
                    PRECIO_SER = decimal.Parse(reader["PRECIO_SER"].ToString()),
                    TERMINOS_SER = reader["TERMINOS_SER"].ToString(),
                    NOMBRE_CAT = reader["NOMBRE_CAT"].ToString()
            };
                lista.Add(oServicios);
            }
            cadena.Close();
            return lista;
        }
    }
}