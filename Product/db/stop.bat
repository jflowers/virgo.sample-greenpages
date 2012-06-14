@echo off
setlocal

call h2
java -cp "%H2CP%" org.h2.tools.Server -tcpShutdown tcp://localhost:9092