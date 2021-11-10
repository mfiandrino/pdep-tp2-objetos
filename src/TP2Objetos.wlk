class Mensajero
{
	var property sector
	method puedeMandar(mensaje) = mensaje.length() >= 20
}

object chasqui
{
	method puedeMandar(mensaje) = mensaje.length() < 50
	method costo(mensaje) = mensaje.length() * 2
}

object sherpa
{
	var property valorMensaje = 60

	method puedeMandar(mensaje) = mensaje.length().even()
	method costo(mensaje) = valorMensaje
}

object messich
{
	var property valorCosto = 10
	
	method puedeMandar(mensaje) = not mensaje.startsWith('a') //Otra opción podría ser mensaje.take(1) != 'a' 
	method costo(mensaje) = valorCosto * mensaje.words().size()
}

object pali
{
	method puedeMandar(mensaje) = self.esPalindromo(mensaje)
	
	method esPalindromo(mensaje)
	{
		const mensajeSinEspacios = mensaje.words().join("")
		return mensajeSinEspacios.equalsIgnoreCase(mensajeSinEspacios.reverse())
	}
	
	method costo(mensaje)
	{
		const costo = mensaje.length() * 4
		return costo.min(80)
	} 
}

object pichca
{
	method puedeMandar(mensaje) = mensaje.words().size() > 3
	method costo(mensaje) = mensaje.size() * (3.randomUpTo(7))
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


//Punto 8:
object mensajeElocuente{
	method gradoDeElocuencia(mensaje){
	return	mensaje.words().filter({palabra => palabra.size() < 3 }).size() +1
	}
	method ganancia(mensaje){
		if(mensaje.size() < 30){
			return 500 * self.gradoDeElocuencia(mensaje)
			} else {
				return 900 * self.gradoDeElocuencia(mensaje)
			}
	}
	method costo(mensaje){
		return 0.1 * self.ganancia(mensaje)
	}
}


//Punto 9:

object mensajeCifrado {
	method entregarAlRevez(mensaje) = mensaje.reverse()
	method costoMensajeCifrado(mensaje, mensajero) = mensajero.costo(mensaje) + 3 * mensaje.indexOf("a")
	}
	
