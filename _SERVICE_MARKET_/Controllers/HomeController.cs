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
    }
}