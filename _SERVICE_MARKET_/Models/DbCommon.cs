using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace _SERVICE_MARKET_.Models
{
    public class DbCommon
    {
        private static string cadena = "Data Source=LAPTOP-RMAAM810;Initial Catalog=SERVICE_MARKET;Integrated Security=True";

        public static IDbConnection Conexion()
        {
            return new SqlConnection(cadena);
        }
    }
}