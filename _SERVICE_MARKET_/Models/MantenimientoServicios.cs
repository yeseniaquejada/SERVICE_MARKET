using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

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
            Comand.Parameters.Add(new SqlParameter("@NOMBRE_SER", oServicios.NOMBRE_SER));
            Comand.Parameters.Add(new SqlParameter("@PRECIO_SER", oServicios.PRECIO_SER));
            Comand.Parameters.Add(new SqlParameter("@DESCRIPCION_BREVE", oServicios.DESCRIPCION_BREVE));
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
                    ID_SERVICIO = int.Parse(reader["ID_SERVICIO"].ToString()),
                    NOMBRE_SER = reader["NOMBRE_SER"].ToString(),
                    PRECIO_SER = decimal.Parse(reader["PRECIO_SER"].ToString()),
                    DESCRIPCION_BREVE = reader["DESCRIPCION_BREVE"].ToString(),
                    NOMBRE_CAT = reader["NOMBRE_CAT"].ToString()
                };
                lista.Add(oServicios);
            }
            cadena.Close();
            return lista;
        }

        //METODO PARA CONSULTAR MAS INFORMACION SOBRE UN SERVICIO
        public Servicio Informacion_Servicios(int ID_SERVICIO)
        {
            cadena.Open();
            SqlCommand Comand = new SqlCommand("CONSULTAR_PUBLICACION", cadena as SqlConnection);
            Comand.Parameters.Add("@ID_SERVICIO", SqlDbType.Int);
            Comand.Parameters["@ID_SERVICIO"].Value = ID_SERVICIO;
            Comand.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = Comand.ExecuteReader();

            Servicio oDetalle_Servicios = new Servicio();
            if (reader.Read())
            {
                oDetalle_Servicios.ID_SERVICIO = int.Parse(reader["ID_SERVICIO"].ToString());
                oDetalle_Servicios.NOMBRE_SER = reader["NOMBRE_SER"].ToString();
                oDetalle_Servicios.PRECIO_SER = decimal.Parse(reader["PRECIO_SER"].ToString());
                oDetalle_Servicios.DESCRIPCION_BREVE = reader["DESCRIPCION_BREVE"].ToString();
                oDetalle_Servicios.TERMINOS_SER = reader["TERMINOS_SER"].ToString();
                oDetalle_Servicios.NOMBRE_CAT = reader["NOMBRE_CAT"].ToString();
                oDetalle_Servicios.NOMBRE_USU = reader["NOMBRE_USU"].ToString();
                oDetalle_Servicios.APELLIDOS_USU = reader["APELLIDOS_USU"].ToString();
                oDetalle_Servicios.CELULAR_USU = reader["CELULAR_USU"].ToString();
                oDetalle_Servicios.CORREO_ELECTRONICO = reader["CORREO_ELECTRONICO"].ToString();
                oDetalle_Servicios.NOMBRE_CIUDAD = reader["NOMBRE_CIUDAD"].ToString();
            }
            cadena.Close();
            return oDetalle_Servicios;
        }

        //METODO PARA CATEGORIZAR SERVICIOS

        public Servicio CategorizarServicios(int ID_CATEGORIA)
        {
            cadena.Open();
            SqlCommand Comand = new SqlCommand("SERVICIOS_CATEGORIAS", cadena as SqlConnection);
            Comand.Parameters.Add("@ID_CATEGORIA", SqlDbType.Int);
            Comand.Parameters["@ID_CATEGORIA"].Value = ID_CATEGORIA;
            Comand.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = Comand.ExecuteReader();
            Servicio categorizar = new Servicio();
            if (reader.Read())
            {
                categorizar.ID_CATEGORIA = int.Parse(reader["ID_CATEGORIA"].ToString());
                categorizar.ID_SERVICIO = int.Parse(reader["ID_SERVICIO"].ToString());
                categorizar.NOMBRE_SER = reader["NOMBRE_SER"].ToString();
                categorizar.PRECIO_SER = decimal.Parse(reader["PRECIO_SER"].ToString());
                categorizar.DESCRIPCION_BREVE = reader["DESCRIPCION_BREVE"].ToString();
                categorizar.NOMBRE_CAT = reader["NOMBRE_CAT"].ToString();
            }
            cadena.Close();
            return categorizar;
        }
}