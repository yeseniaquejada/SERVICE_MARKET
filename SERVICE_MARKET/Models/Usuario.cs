using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SERVICE_MARKET.Models
{
    public class Usuario
    {
        public int ID_USUARIO { get; set; }
        public string IDENTIFICACION_U { get; set; }
        public string TIPO_DOC { get; set; }
        public string NOMBRE { get; set; }
        public string APELLIDOS { get; set; }
        public string CELULAR { get; set; }
        public string CORREO_ELECTRONICO { get; set; }
        public string CONTRASENA { get; set; }
        public string CONFIRMAR_CONTRASENA { get; set; }
        public string FECHA_NACIMIENTO { get; set; }
        public int ID_ROL_FK { get; set; }

    }
}