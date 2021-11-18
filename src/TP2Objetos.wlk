class Mensajero
{
	var property tipoDeMensajero
	var property sector	
	method puedeMandar(mensaje) = mensaje.length() >= 20
	method costo(mensaje)
	
	method enviarMensaje(mensaje) = tipoDeMensajero.enviarMensaje(mensaje)
	method cantidadDePalabras(mensaje) = mensaje.words().size()
}

object chasqui inherits Mensajero(sector = enviosRapidos, tipoDeMensajero = paranoico)
{
	override method puedeMandar(mensaje) = super(mensaje) && mensaje.length() < 50
	override method costo(mensaje) = mensaje.length() * 2
}

object sherpa inherits Mensajero(sector = enviosEstandar, tipoDeMensajero = new Alegre(alegria = 100))
{
	var property valorMensaje = 60

	override method puedeMandar(mensaje) = super(mensaje) && mensaje.length().even()
	override method costo(mensaje) = valorMensaje
}

object messich inherits Mensajero(sector = enviosVIP, tipoDeMensajero = new Serio())
{
	var property valorCosto = 10
	
	override method puedeMandar(mensaje) = super(mensaje) && not mensaje.startsWith('a')
	override method costo(mensaje) = valorCosto * mensaje.words().size()
}

object pali inherits Mensajero(sector = enviosRapidos, tipoDeMensajero = paranoico)
{
	override method puedeMandar(mensaje) = super(mensaje) && self.esPalindromo(mensaje)
	
	method esPalindromo(mensaje)
	{
		const mensajeSinEspacios = mensaje.words().join("")
		return mensajeSinEspacios.equalsIgnoreCase(mensajeSinEspacios.reverse())
	}
	
	override method costo(mensaje)
	{
		const costo = mensaje.length() * 4
		return costo.min(80)
	} 
}

object pichca inherits Mensajero(sector = enviosEstandar, tipoDeMensajero = new Serio())
{
	override method puedeMandar(mensaje) = super(mensaje) && self.cantidadDePalabras(mensaje) > 3
	override method costo(mensaje) = mensaje.size() * (3.randomUpTo(7))
}

class MensajeroEstandar inherits Mensajero
{	
	override method costo(mensaje) = self.cantidadDePalabras(mensaje) * sector.cobro()
}

class Sector
{
	var property cobro	
}

const enviosRapidos = new Sector(cobro = 20)
const enviosEstandar = new Sector(cobro = 15)
const enviosVIP = new Sector(cobro = 30)

object paranoico
{
	method enviarMensaje(mensaje) = new MensajeCifrado(contenido = mensaje)
}

class Alegre
{
	var property alegria
	method enviarMensaje(mensaje)
	{
		if(alegria > 10)
		{
			var dur
			if(alegria.even())
				dur = 6 * alegria
			else
				dur = 500
			return new MensajeCantado(contenido = mensaje, duracion = dur)
		}
		else
			return new Mensaje(contenido = mensaje)
	}
}

class Serio
{
	const mensajes = []
	
	method enviarMensaje(mensaje)
	{
		if(mensajes.size() < 3)
		{
			mensajes.add(mensaje)
			return new MensajeElocuente(contenido = mensaje)
		}
		else
			return new MensajeCifrado(contenido = mensaje)
	}	
}

object agenciaMensajeria
{
	const property historial = []
	const mensajeros = [chasqui,sherpa,messich,pali, new MensajeroEstandar(sector=enviosEstandar, tipoDeMensajero = new Serio())]
	
	method recibirMensaje(mensaje)
	{
		self.verificarMensajeVacio(mensaje)
		self.registrarEntrada(mensaje,self.pedirMensajero(mensaje))
	}
	
	method verificarMensajeVacio(mensaje)
	{
		if(mensaje.isEmpty())
			throw new DomainException(message = "El mensaje esta vacio, no puede realizarse la operacion")
	}
	
	method mensajerosPosibles(mensaje)
	{
		const mensajerosPosibles = mensajeros.filter({unMensajero => unMensajero.puedeMandar(mensaje)})
		if(mensajerosPosibles.isEmpty())
			throw new DomainException(message = "No hay mensajeros para enviar ese mensaje")
		return mensajerosPosibles
	}
	
	method pedirMensajero(mensaje) = self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})
	
	method registrarEntrada(mensaje,mensajero)
	{
		historial.add(new EntradaHistorial(mensajeH = mensajero.enviarMensaje(mensaje), mensajeroH = mensajero))
	}

	// 4) Ganancia neta del mes - Común
	method historialDelMes() = historial.filter({input => input.fechaH() >= new Date().minusDays(30)})
	method gananciaNetaDelMes() = self.historialDelMes().sum({input => input.gananciaPorMensaje()})
	
	// 5) Empleado del mes - Común
	method obtenerEmpleadoDelMes()
	{
		const losMensajerosQueEnviaron = self.historialDelMes().map({input => input.mensajeroH()})
		return losMensajerosQueEnviaron.max({mensajero => losMensajerosQueEnviaron.occurrencesOf(mensajero)})
	}	
}

class EntradaHistorial 
{
	var property mensajeH
	var property mensajeroH
	var property fechaH = new Date()

	method gananciaPorMensaje() = mensajeH.ganancia() - mensajeH.costo(mensajeroH)
}

class Mensaje
{
	var property contenido
	
	method ganancia()
	{
		if(contenido.size() < 30)
			return 500
		else
			return 900
	}
	
	method costo(mensajero) = mensajero.costo(contenido)
}

class MensajeCantado inherits Mensaje
{
	var property duracion
	override method costo(mensajero) = super(mensajero) * 0.1
}

//Punto 8:
class MensajeElocuente inherits Mensaje
{
	method gradoDeElocuencia() = contenido.words().filter({palabra => palabra.size() < 3 }).size() + 1
	override method ganancia() = super() * self.gradoDeElocuencia()
}

//Punto 9:
class MensajeCifrado inherits Mensaje
{
	override method contenido() = contenido.reverse()
	override method costo(mensajero) = super(mensajero) + 3 * contenido.indexOf("a")
}


