plugins {
    id("org.jetbrains.kotlin.jvm") version "1.5.21" // Uygun bir Kotlin eklentisi
    // id("buildlogic.kotlin-library-conventions") // Bu eklenti kaldırıldı
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}
