
// Punto 1) Integrante 1
object pichca
{
	method puedeMandar(mensaje) = true // solo para que no me tire el error al ejecutar
	method costo(mensaje) = 0 // solo para que no me tire el error al ejecutar
}

// Punto 2) Integrante 2
object mensajeroEstandar
{
	method puedeMandar(mensaje) = true // solo para que no me tire el error al ejecutar
	method costo(mensaje) = 1 // solo para que no me tire el error al ejecutar
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
	method mensajerosPosibles(mensaje) = mensajeros.filter({unMensajero => unMensajero.puedeMandar(mensaje)}) // igual que el tp1
	
	method pedirMensajero(mensaje) = self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})// igual que el tp1
	
}



//Punto 9:

object mensajeCifrado {
	method entregarAlRevez(mensaje) = mensaje.reverse()
	method costoMensajeCifrado(mensaje, mensajero) = mensajero.costo(mensaje) + 3 * mensaje.indexOf("a")
	}
	
