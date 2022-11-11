using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace Service_market_.Models
{
    public class MantenimientoServicios
    {
        /*CADENA DE CONEXION*/
        IDbConnection cadena = DBCommon.Conexion();

        //METODO DE AGREGAR SERVICIOS
        public int AgregarServicio(Servicios oServicios)
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
        public List<Servicios> ConsultarServicios()
        {
            cadena.Open();
            SqlCommand Comand = new SqlCommand("CONSULTAR_SERVICIOS", cadena as SqlConnection);
            Comand.CommandType = CommandType.StoredProcedure;
            IDataReader reader = Comand.ExecuteReader();
            List<Servicios> lista = new List<Servicios>();
            while (reader.Read())
            {
                Servicios oServicios = new Servicios();
                oServicios.IMAGEN_SER = reader.GetString(0);
                oServicios.NOMBRE_SER = reader.GetString(1);
                oServicios.PRECIO_SER = reader.GetDecimal(2);
                oServicios.TERMINOS_SER = reader.GetString(3);
                oServicios.NOMBRE_CAT = reader.GetString(4);
                lista.Add(oServicios);
            }
            cadena.Close();
            return lista;
        }
    }
}