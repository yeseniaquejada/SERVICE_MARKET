using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace _SERVICE_MARKET_.Models
{
    public class Servicio
    {
        public int ID_SERVICIO { get; set; }
        public string NOMBRE_SER { get; set; }
        public decimal PRECIO_SER { get; set; }
        public string DESCRIPCION_BREVE { get; set; }
        public string TERMINOS_SER { get; set; }
        public int ID_CATEGORIA_FK { get; set; }
        public string NOMBRE_CAT { get; set; }
    }
}