/-
  Network, Authentication, and Connection types.
  Translation of the Coq Network_type, auth_type, Connection_type classes.
-/
-- Pair type class (marker class)
class PairType (t_a : Type) (t_b : Type)
-- A simple string type placeholder (Lean has String natively)
inductive SimpleString : Type where
  | someString
-- Network typeclass
class NetworkType (t_address : Type) (t_connection : Type) where
  net_connect   : t_address → t_connection
  net_tracert   : t_address → t_connection
  net_ping      : t_address → t_connection
  net_whois     : t_address → t_connection
  net_tcpdump   : t_address → t_connection
  net_proxy     : t_address → t_connection
  net_mitmproxy : t_address → t_connection
  net_subnet    : t_address → t_connection
-- Network record types
structure TNetworkType where
  t_address : Type
  t_connection : Type
-- Note: In Coq, TNetwork_type2 stored Types as constructor fields.
-- In Lean, storing `Type` in a Type-level inductive requires universe polymorphism.
-- We use `Type 1` for the inductive to accommodate this.
inductive TNetworkType2 : Type 1 where
  | tNetworkType2a2 (t_address : Type) (t_connection : Type)
  | tNetworkType2b2 (t_address : Type)
inductive Socket : Type where
  | fileHandle
inductive TNetworkType3 : Type where
  | tNetworkType2a (t_address : SimpleString) (t_connection : Socket)
  | tNetworkType2b (t_address : SimpleString)
-- Authentication typeclass
class AuthType (t_key : Type) (t_auth : Type) where
  authenticate  : t_key → t_auth
  auth_share    : t_key
  auth_generate : t_key
  auth_revoke   : t_key
  auth_refresh  : t_key
structure TAuthType where
  t_key : Type
  t_auth : Type
-- Connection typeclass
class ConnectionType
    (t_address : Type)
    (t_key : Type)
    (t_auth : Type)
    (t_state_machine : Type)
    (t_connection : Type) where
  ct_connect    : t_address → t_connection
  ct_state      : t_connection → t_state_machine
  ct_disconnect : t_address → t_connection
structure TConnectionType where
  ct_key : Type
  ct_auth : Type
  ct_address : Type
  ct_state_machine : Type
class ConnectionType2
    (t_auth : Type)
    (t_network : Type)
    (t_protocol : Type)
    (t_connection : Type) where
  connect : t_auth → t_network → t_protocol → t_connection
structure TConnectionType2 where
  ct2_auth : Type
  ct2_network : Type
  ct2_protocol : Type
  ct2_connection : Type
