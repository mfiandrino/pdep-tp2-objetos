
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

// Punto 3) Integrante 3 - Modificación del tp1\

class EntradaHistorial {
	var mensaje
	var mensajero
	var costo
	var fecha
	
	method gananciaPorMensaje(){
		if(mensaje.size() < 30){
			return (500 - mensajero.costo(mensaje))
			} else {
				return 900 - mensajero.costo(mensaje)
			}
	}
	method mensajeEnviado() = mensaje
	method mensajero() = mensajero
	method costo() = costo
	method fecha() = fecha
	
	
}

const hoy = new Date() /* (Segun documentación Wollok) Una fecha es un objeto inmutable que representa un día, 
 						mes y año (sin horas ni minutos). Se crean de dos maneras posibles:
						const hoy = new Date()  
        				toma la fecha del día
`						const unDiaCualquiera = new Date(day = 30, month = 6, year = 1973)  
        				se ingresa en formato día, mes y año */

object agenciaMensajeria
{
	const mensajeros = [pichca, mensajeroEstandar]
	var historial = []
	
	method historial() = historial
	
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
		var mensajeroElegido = self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})	
		historial.add(new EntradaHistorial(mensaje = mensaje, mensajero = mensajeroElegido, fecha = new Date(), costo = mensajeroElegido.costo(mensaje)))
		return mensajeroElegido
		}
		
// 4) Ganancia neta del mes - Común

	method historialDelMes() = historial.filter{input => input.fecha() >= hoy.minusDays(30)}
	
	method GananciaNetaXMes() = self.historialDelMes().sum{input => input.gananciaPorMensaje()}
	
// 5) Empleado del mes - Común
	method obtenerEmpleadoDelMes(){
		const historialFiltrado = self.historialDelMes()
		const losMensajerosQueEnviaron = historialFiltrado.map{input => input.mensajero()}
		return losMensajerosQueEnviaron.max{mensajero => losMensajerosQueEnviaron.occurrencesOf(mensajero)} // Counts the occurrences of a given element in self collection.returns an integer number
		
		}
	}





//Punto 9:

object mensajeCifrado {
	method entregarAlRevez(mensaje) = mensaje.reverse()
	method costoMensajeCifrado(mensaje, mensajero) = mensajero.costo(mensaje) + 3 * mensaje.indexOf("a")
	}
	
