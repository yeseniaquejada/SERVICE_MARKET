using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using SERVICE_MARKET.Models;

namespace SERVICE_MARKET.Controllers
{
    public class ProveedorController : Controller
    {
        // GET: Proveedor
        public ActionResult IndexProveedor()
        {
            return View();
        }

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

            ma.CrearPublicacion(serv);
            return RedirectToAction("MisPublicaciones");
        }

        public ActionResult CerrarSesion()
        {
            Session["Usuario"] = null;
            return RedirectToAction("Index", "Home");
        }
    }
}