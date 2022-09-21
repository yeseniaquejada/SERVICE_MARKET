using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SERVICE_MARKET.Controllers
{
    public class ClienteController : Controller
    {
        // GET: Cliente
        public ActionResult IndexCliente()
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