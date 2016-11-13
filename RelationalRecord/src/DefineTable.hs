{-# LANGUAGE TemplateHaskell #-}

{-|
Module      :  DefineTable
Copyright   :  (c) VacationLabs
Maintainer  :  michaelkarg77@gmail.com

This module provides the TH function which reads the DB catalog at
compile time and generates Haskell data types from it.
-}

module  DefineTable
        ( defineTable
        , module DataSource
        ) where


import  DataSource

import  Language.Haskell.TH                 (Q, Dec)

import  Database.HDBC.Query.TH              (defineTableFromDB')
import  Database.HDBC.Schema.PostgreSQL     (driverPostgreSQL)
import  Database.HDBC.Schema.Driver         (typeMap)
import  Database.Relational.Query.Component (Config(..), defaultConfig)
import  Data.ByteString                     (ByteString)


defineTable :: String -> Q [Dec]
defineTable tableName =
    defineTableFromDB' getDataSource
        (defaultConfig {verboseAsCompilerWarning = False})
        (withAdditionalTypes driverPostgreSQL)
        schemaName tableName
        [''Show]
  where
    withAdditionalTypes driver =
        driver {typeMap = ("jsonb", [t| ByteString |]) : typeMap driver}        -- FIXME should work, but doesn't!