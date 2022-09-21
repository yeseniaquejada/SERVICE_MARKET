using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SERVICE_MARKET.Models
{
    public class Servicios
    {
        public int ID_SERVICIO { get; set; }
        public string IMAGEN { get; set; }
        public string NOMBRE { get; set; }
        public decimal PRECIO { get; set; }
        public string TERMINOS { get; set; }
        public int ID_CATEGORIA_FK { get; set; }
    }
}