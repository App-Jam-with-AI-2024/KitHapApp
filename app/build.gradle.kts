plugins {
    kotlin("jvm") version "1.5.21"
    id("application")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}

application {
    mainClass.set("com.example.MainKt")
}
