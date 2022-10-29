using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Service_market_.Models
{
    //INSTANCIAR METODOS
    public class ServiciosBL
    {
        MantenimientoServicios _servicios = new MantenimientoServicios();
        public int AgregarServicio(Servicios oServicios)
        {
            return _servicios.AgregarServicio(oServicios);
        }
        public List<Servicios> ConsultarServicios()
        {
            return _servicios.ConsultarServicios();
        }
    }
}