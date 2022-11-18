using _SERVICE_MARKET_.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _SERVICE_MARKET_.Controllers
{
    public class ServiciosController : Controller
    {
        // GET: Servicios
        public ActionResult IndexUsuarios()
        {
            return View();
        }
        public ActionResult ServiciosDisponibles()
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            return View(ma.ConsultarServicios());

        }

        public ActionResult Publicar()
        {
            return View();
        }

        // POST: Home/Create
        [HttpPost]
        public ActionResult Publicar(FormCollection collection)
        {
            MantenimientoServicios ma = new MantenimientoServicios();
            Servicio oServicios = new Servicio
            {
                NOMBRE_SER = collection["NOMBRE_SER"],
                PRECIO_SER = decimal.Parse(collection["PRECIO_SER"].ToString()),
                DESCRIPCION_BREVE = collection["DESCRIPCION_BREVE"],
                TERMINOS_SER = collection["TERMINOS_SER"],
                ID_CATEGORIA_FK = int.Parse(collection["ID_CATEGORIA_FK"])
            };
            ma.AgregarServicio(oServicios);
            return RedirectToAction("IndexUsuarios");
        }
    }
}