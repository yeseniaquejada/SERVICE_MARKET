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

        ServiciosBL _bl = new ServiciosBL();

       public ActionResult ServiciosConsultar()
        {
            ViewBag.ListaServicios = _bl.ConsultarServicios().ToList();
            return View();
        }
        public ActionResult ServiciosPublicar()
        {
            return View();
        }
        [HttpPost]
        public ActionResult ServiciosPublicar(Servicios oServicios)
        {
            _bl.AgregarServicio(oServicios);
            return RedirectToAction("ServiciosConsultar");
        }
    }
}