﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _SERVICE_MARKET_.Models
{
    public class Usuario
    {
        public string TIPO_DOC { get; set; }
        public string N_IDENTIFICACION { get; set; }
        public string FECHA_NACIMIENTO { get; set; }
        public string FECHA_EXPEDICION { get; set; }
        public string NOMBRE_USU { get; set; }
        public string APELLIDOS_USU { get; set; }
        public string CELULAR_USU { get; set; }
        public string GENERO { get; set; }
        public int ID_CIUDAD_FK { get; set; }
        public string DIRECCION { get; set; }
        public string CORREO_ELECTRONICO { get; set; }
        public string CONTRASENA { get; set; }
        public string CONFIRMAR_CONTRASENA { get; set; }
    }
}