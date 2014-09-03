module ParseStructs where

import Text.ParserCombinators.Parsec
import Data.Maybe(catMaybes)

data Struct = Struct {struct_name   :: String
                     ,struct_fields :: [Field]
} deriving(Show, Eq)

data Field = Field {field_name :: String
                   ,field_type :: [String]
} deriving(Show, Eq)

c_symbol = many1 $ try alphaNum <|> char '_'
spaces1  = many1 space

struct = do spaces
            _ <- string "struct"
            spaces
            name <- c_symbol
            spaces
            fields <- between (char '{') (char '}') parseFields
            spaces
            _ <- char ';'
            return $ Struct (name) fields
        where parseFields = do x <- endBy parseField endField
                               spaces
                               return x
              endField    = do string ";"
                               spaces

parseField = (try parsePointer)
         <|> (try parseValue)

parsePointer = do spaces
                  ts   <- endBy c_symbol spaces1
                  spaces
                  star <- string "*"
                  spaces
                  nm   <- c_symbol
                  spaces
                  return $ Field nm (ts ++ [star])

parseValue = do spaces
                symbols <- sepBy (try c_symbol) spaces1
                spaces
                return $ Field (last symbols)
                               (init symbols)

file = do maybe_structs <- sepBy line spaces1
          return $ catMaybes maybe_structs
        where line = (try $ struct     >>= return . Just)
                 <|> (try $ ignoreLine >>  return Nothing)
              ignoreLine = many $ noneOf "\n"

parseFile :: [Char] -> Either ParseError [Struct]
parseFile = parse file "(unknown)"