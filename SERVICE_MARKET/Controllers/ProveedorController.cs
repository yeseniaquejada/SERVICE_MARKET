using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SERVICE_MARKET.Controllers
{
    public class ProveedorController : Controller
    {
        // GET: Proveedor
        public ActionResult IndexProveedor()
        {
            return View();
        }

        public ActionResult CrearPublicacion()
        {
            return View();
        }

        public ActionResult CerrarSesion()
        {
            Session["Usuario"] = null;
            return RedirectToAction("Index", "Home");
        }
    }
}