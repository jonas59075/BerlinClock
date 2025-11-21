import qualified Data.Binary as B
import qualified Data.Binary.Put as P
import qualified Data.ByteString.Lazy as BL
import qualified Data.Map.Strict as Map
import Data.Word
import Data.Int

newtype Utf8 = Utf8 { unUtf8 :: [Word8] } deriving (Eq, Ord)

mkUtf8 :: String -> Utf8
mkUtf8 = Utf8 . map (fromIntegral . fromEnum)

instance B.Binary Utf8 where
  get = fail "not implemented"
  put (Utf8 bytes) = do
    P.putWord8 (fromIntegral (length bytes))
    mapM_ P.putWord8 bytes

data Name = Name Utf8 Utf8 deriving (Eq, Ord)
instance B.Binary Name where
  get = fail "not implemented"
  put (Name author project) = B.put author >> B.put project

data Version = Version Word8 Word8 Word8
instance B.Binary Version where
  get = fail "not implemented"
  put (Version a b c) = P.putWord8 a >> P.putWord8 b >> P.putWord8 c

data KnownVersions = KnownVersions Version [Version]
instance B.Binary KnownVersions where
  get = fail "not implemented"
  put (KnownVersions newest prev) = do
    B.put newest
    B.put prev

data Registry = Registry Int (Map.Map Name KnownVersions)
instance B.Binary Registry where
  get = fail "not implemented"
  put (Registry count versions) = do
    B.put (fromIntegral count :: Int64)
    B.put versions

mkEntry :: (String, String, Version) -> (Name, KnownVersions)
mkEntry (a,p,v) = (Name (mkUtf8 a) (mkUtf8 p), KnownVersions v [])

mkVersion :: Word8 -> Word8 -> Word8 -> Version
mkVersion = Version

packages :: [(Name, KnownVersions)]
packages = fmap mkEntry
  [ ("elm", "browser", mkVersion 1 0 2)
  , ("elm", "bytes", mkVersion 1 0 8)
  , ("elm", "core", mkVersion 1 0 5)
  , ("elm", "file", mkVersion 1 0 5)
  , ("elm", "html", mkVersion 1 0 1)
  , ("elm", "http", mkVersion 2 0 0)
  , ("elm", "json", mkVersion 1 1 4)
  , ("elm", "time", mkVersion 1 0 0)
  , ("elm", "url", mkVersion 1 0 0)
  , ("elm", "virtual-dom", mkVersion 1 0 5)
  , ("elm", "random", mkVersion 1 0 0)
  , ("elm-explorations", "test", mkVersion 2 2 0)
  ]

main :: IO ()
main = do
  let registry = Registry (length packages) (Map.fromList packages)
  BL.writeFile "/workspace/BerlinClock/elm.tmp/0.19.1/packages/registry.dat" (B.encode registry)
