using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Service_market_.Models
{
    public class Servicios
    {
        public int ID_SERVICIO { get; set; }
        public string IMAGEN_SER { get; set; }
        public string NOMBRE_SER { get; set; }
        public decimal PRECIO_SER { get; set; }
        public string TERMINOS_SER { get; set; }
        public int ID_CATEGORIA_FK { get; set; }   
    }
}