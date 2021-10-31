
// Punto 1) Integrante 1
object pichca
{
	method puedeMandar(mensaje) = mensaje.size() > 2 // solo para testear el punto 3
	method costo(mensaje) = 0 // solo para que no me tire el error al ejecutar
}

// Punto 2) Integrante 2
object mensajeroEstandar
{	
	var cantPalabras = 0
	var costoTipoEnvio = 0
	const tipoEnvio = "VIP"
	
	method puedeMandar(mensaje) =	mensaje.size() <= 20
	method cantidadDePalabras(mensaje) {
		cantPalabras = mensaje.words().size()
		return cantPalabras
	}
	method costo(mensaje) {
		return self.costoTipoEnvios() * self.cantidadDePalabras(mensaje)
	}
	method costoTipoEnvios() {
		if (tipoEnvio == "VIP") {
			costoTipoEnvio = 30
		}
		else if (tipoEnvio == "rapido") {
			costoTipoEnvio = 20
		}
		else if (tipoEnvio == "estandar") {
			costoTipoEnvio = 15
		}
		return costoTipoEnvio	
	}
}

// Punto 3) Integrante 3 - Modificación del tp1

object agenciaMensajeria
{
	const mensajeros = [pichca, mensajeroEstandar]
	
	method verificarMensaje(mensaje){
		if(mensaje.isEmpty()) {
			self.error("No se puede enviar mensajes vacíos")
		} return true
	}
	method mensajerosPosibles(mensaje){
	const mensajeroPosible = mensajeros.filter({unMensajero => unMensajero.puedeMandar(mensaje)})
	if(mensajeroPosible.isEmpty()){
		self.error("No existen mensajeros que puedan enviar este mensaje")
		} return mensajeroPosible
	}
	method pedirMensajero(mensaje) {
		return self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})	
		//return 
		}

}



//Punto 9:

object mensajeCifrado {
	method entregarAlRevez(mensaje) = mensaje.reverse()
	method costoMensajeCifrado(mensaje, mensajero) = mensajero.costo(mensaje) + 3 * mensaje.indexOf("a")
	}
	
