@echo off
call ..\Build\set.env.cmd
cd "C:\Virgo\virgo-tomcat-server-3.0.3.RELEASE\bin"
title virgo tomcat server
call startup.bat -clean