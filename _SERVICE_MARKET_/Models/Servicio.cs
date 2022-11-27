namespace _SERVICE_MARKET_.Models
{
    public class Servicio
    {
        /*SERVICIO*/
        public int ID_SERVICIO { get; set; }
        public string NOMBRE_SER { get; set; }
        public decimal PRECIO_SER { get; set; }
        public string DESCRIPCION_BREVE { get; set; }
        public string TERMINOS_SER { get; set; }
        public int ID_CATEGORIA_FK { get; set; }

        /*CATEGORIAS*/
        public int ID_CATEGORIA { get; set; }
        public string NOMBRE_CAT { get; set; }
        public string DESCRIPCION_CAT { get; set; }

        /*USUARIO*/
        public string NOMBRE_USU { get; set; }
        public string APELLIDOS_USU { get; set; }
        public string CELULAR_USU { get; set; }
        public string CORREO_ELECTRONICO { get; set; }

        /*CIUDAD*/
        public string NOMBRE_CIUDAD { get; set; }
    }
}