package com.example.notas

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.core.os.LocaleListCompat

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { MaterialTheme { AccesoTraducido(total = 2) } }
    }
}

@Composable
fun AccesoTraducido(total: Int) {
    var correo by rememberSaveable { mutableStateOf("") }
    var clave by remember { mutableStateOf("") }
    var error by rememberSaveable { mutableStateOf<Int?>(null) }

    Column(Modifier.padding(24.dp)) {
        Text(stringResource(R.string.welcome, "Ana"))
        Text(pluralStringResource(R.plurals.note_count, total, total))
        OutlinedTextField(
            value = correo,
            onValueChange = { correo = it },
            label = { Text(stringResource(R.string.email)) },
            singleLine = true
        )
        OutlinedTextField(
            value = clave,
            onValueChange = { clave = it },
            label = { Text(stringResource(R.string.password)) },
            singleLine = true,
            visualTransformation = PasswordVisualTransformation()
        )
        Button(onClick = {
            error = when {
                "@" !in correo -> R.string.error_email
                clave.isBlank() -> R.string.error_password
                else -> R.string.error_access
            }
        }) {
            Text(stringResource(R.string.sign_in))
        }
        error?.let { Text(stringResource(it)) }
        SelectorIdioma()
    }
}

@Composable
private fun SelectorIdioma() {
    val opciones = listOf(
        "" to R.string.language_system,
        "es" to R.string.language_spanish,
        "en" to R.string.language_english
    )

    for ((etiqueta, texto) in opciones) {
        TextButton(onClick = {
            val idiomas = LocaleListCompat.forLanguageTags(etiqueta)
            AppCompatDelegate.setApplicationLocales(idiomas)
        }) {
            Text(stringResource(texto))
        }
    }
}
