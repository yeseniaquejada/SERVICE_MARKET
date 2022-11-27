using _SERVICE_MARKET_.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _SERVICE_MARKET_.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            return View(ma.ConsultarServicios());
        }

        public ActionResult preguntasFrecuentes()
        {
            return View();
        }

        public ActionResult PQR()
        {
            return View();
        }
        public ActionResult Categorias(int ID)
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            Servicio ser = ma.CategorizarServicios(ID);
            return View(ser);
        }
    }
}