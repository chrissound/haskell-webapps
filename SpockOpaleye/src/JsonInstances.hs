{-# LANGUAGE OverloadedStrings #-}

module JsonInstances where

import DataTypes
import Data.Aeson
import Data.Aeson.Types
import Control.Monad
import Data.Text

instance FromJSON UserId where
  parseJSON j@(Number v) = UserId <$> (parseJSON j)
  parseJSON invalid = typeMismatch "UserId" invalid

instance FromJSON TenantId where
  parseJSON j@(Number v) = TenantId <$> (parseJSON j)
  parseJSON invalid = typeMismatch "TenantId" invalid

instance FromJSON TenantStatus where
  parseJSON j@(String v) = t_status <$> (parseJSON j)
    where
      t_status :: Text -> TenantStatus
      t_status "active" = TenantStatusActive
      t_status "inactive" = TenantStatusInActive
      t_status "new" = TenantStatusNew
  parseJSON invalid = typeMismatch "TenantStatus" invalid

instance FromJSON Tenant where
  parseJSON (Object v) = Tenant <$>
    v .: "id" <*>
    v .: "name" <*>
    v .: "firstname" <*>
    v .: "lastname" <*>
    v .: "email" <*>
    v .: "phone" <*>
    v .: "status" <*>
    v .: "userId" <*>
    v .: "backofficeDomain"