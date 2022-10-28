using Service_market_.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Service_market_.Controllers
{
    public class ServiciosController : Controller
    {
        // GET: Servicios
        public ActionResult MisPublicaciones()
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            return View(ma.RecuperarTodos());
        }

        public ActionResult CrearPublicacion()
        {
            return View();
        }

        [HttpPost]
        public ActionResult CrearPublicacion(FormCollection collection)
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            Servicios serv = new Servicios
            {
                NOMBRE_CAT = collection["NOMBRE_CAT"],
                IMAGEN = collection["IMAGEN"],
                NOMBRE = collection["NOMBRE"],
                PRECIO = Decimal.Parse(collection["PRECIO"].ToString()),
                TERMINOS = collection["TERMINOS"],
                ID_CATEGORIA_FK = int.Parse(collection["ID_CATEGORIA_FK"].ToString())
            };

            ma.Publicacion(serv);
            return RedirectToAction("MisPublicaciones");
        }
    }
}