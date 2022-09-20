using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SERVICE_MARKET.Permisos;

namespace SERVICE_MARKET.Controllers
{
    [ValidarSesion]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        /*public ActionResult CerrarSesion()
        {
            Session["Usuario"] = null;
            return RedirectToAction("Login", "Acceso");
        }*/
    }
}