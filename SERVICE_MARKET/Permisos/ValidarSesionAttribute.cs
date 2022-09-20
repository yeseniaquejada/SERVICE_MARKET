using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SERVICE_MARKET.Permisos
{
    public class ValidarSesionAttribute : ActionFilterAttribute
    {
        /*METODO QUE PERMITE ENTRAR AL INDEX SOLO SI SE REGISTRO*/
        /*public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (HttpContext.Current.Session["Usuario"] == null)
            {
                filterContext.Result = new RedirectResult("~/Acceso/Login");
            }
            base.OnActionExecuting(filterContext);
        }*/
    }
}