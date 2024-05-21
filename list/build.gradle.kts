plugins {
    id("org.jetbrains.kotlin.jvm") version "1.5.21"
    // id("buildlogic.kotlin-library-conventions") // Bu eklenti bulunamadığı için kaldırıldı
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}
