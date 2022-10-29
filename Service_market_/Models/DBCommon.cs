using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace Service_market_.Models
{
    public class DBCommon
    {
        private static string cadena = "Data Source=LAPTOP-RMAAM810;Initial Catalog=SERVICE_MARKET;Integrated Security=True"; 

        public static IDbConnection Conexion()
        {
            return new SqlConnection(cadena);
        }
    }
}