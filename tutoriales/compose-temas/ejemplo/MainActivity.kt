package com.example.notas

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

private val Claro = lightColorScheme(
    primary = Color(0xFF5343AA),
    onPrimary = Color.White,
    primaryContainer = Color(0xFFE7DFFF),
    onPrimaryContainer = Color(0xFF1C0060),
    surface = Color(0xFFFFFBFF),
    onSurface = Color(0xFF1C1B20)
)

private val Oscuro = darkColorScheme(
    primary = Color(0xFFC9BFFF),
    onPrimary = Color(0xFF2C1975),
    primaryContainer = Color(0xFF433190),
    onPrimaryContainer = Color(0xFFE7DFFF),
    surface = Color(0xFF141318),
    onSurface = Color(0xFFE6E1E9)
)

private enum class ModoTema(val clave: String, val etiqueta: String) {
    SISTEMA("system", "Sistema"),
    CLARO("light", "Claro"),
    OSCURO("dark", "Oscuro")
}

@Composable
private fun TemaNotas(modo: ModoTema, contenido: @Composable () -> Unit) {
    val oscuro = when (modo) {
        ModoTema.SISTEMA -> isSystemInDarkTheme()
        ModoTema.CLARO -> false
        ModoTema.OSCURO -> true
    }

    MaterialTheme(
        colorScheme = if (oscuro) Oscuro else Claro,
        typography = Typography(),
        content = contenido
    )
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val preferencias = getSharedPreferences("apariencia", MODE_PRIVATE)
        val guardado = preferencias.getString("modo_tema", null)
        val inicial = ModoTema.entries.firstOrNull { it.clave == guardado }
            ?: ModoTema.SISTEMA

        setContent {
            var modo by remember { mutableStateOf(inicial) }

            TemaNotas(modo) {
                PantallaTema(modo) { nuevoModo ->
                    modo = nuevoModo
                    preferencias.edit().putString("modo_tema", nuevoModo.clave).apply()
                }
            }
        }
    }
}

@Composable
private fun PantallaTema(modo: ModoTema, cambiarModo: (ModoTema) -> Unit) {
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.surface,
        contentColor = MaterialTheme.colorScheme.onSurface
    ) {
        Column(
            modifier = Modifier.padding(24.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("Mis notas", style = MaterialTheme.typography.headlineMedium)
            Card {
                Text("Lista de lectura", Modifier.padding(16.dp))
            }
            Button(onClick = { cambiarModo(ModoTema.SISTEMA) }) {
                Text("Restablecer tema")
            }
            Text("Apariencia", style = MaterialTheme.typography.titleMedium)
            for (opcion in ModoTema.entries) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    RadioButton(
                        selected = modo == opcion,
                        onClick = { cambiarModo(opcion) }
                    )
                    Text(opcion.etiqueta)
                }
            }
        }
    }
}
