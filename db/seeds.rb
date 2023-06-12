# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

unless Person.any?
  Person.create(name: 'Takashi Sakamoto', gender: 'M', alive: false, birth: '1918-8-28', death: '2003-9-27',
    kanji: '坂本 登志', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Kiku Sakamoto', gender: 'F', alive: false, birth: '1893-1-24', death: '1942-5-23',
    kanji: '坂本 きく', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Kenji Sakamoto', gender: 'M', alive: false, birth: '1889-11-6', death: '1964-1-25',
    kanji: '坂本 兼治', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Chiyo Sakamoto', gender: 'F', alive: false, birth: '1919-1-5', death: '2015-11-18',
    kanji: '坂本 チヨ', description: 'Natural de Hokkaido Entrada em Santos no Brasil em 28 de fevereiro de 1937 no ' \
    'navio Montevideo Maru 40 dias de viagem')
  Person.create(name: 'Satiye Sakamoto Otake', gender: 'F', alive: true, birth: '1941-6-26',
    kanji: '大竹 坂本 幸枝', description: 'Natural de Pompéia/SP')
  Person.create(name: 'Tetuo Nakabaiashi Sakamoto', gender: 'M', alive: true, birth: '1944-3-10',
    description: 'Natural de Paulópolis/SP')
  Person.create(name: 'Armando Massao Sakamoto', gender: 'M', alive: false, birth: '1947-7-27', death: '2017-4-26',
    description: 'Natural de Paulópolis SP')
  Person.create(name: 'Julio Minor Sakamoto', gender: 'M', alive: true, birth: '1950-10-10')
  Person.create(name: 'Helena Yoriko Ueno', gender: 'F', alive: true, birth: '1950-10-10')
  Person.create(name: 'Emilia Setuko Sakamoto', gender: 'F', alive: true, birth: '1952-4-29')
  Person.create(name: 'Alice Sakamoto', gender: 'F', alive: false, birth: '1956-7-26')
  Person.create(name: 'Marina Sakamoto', gender: 'F', alive: false, birth: '1958-1-11', death: '1998-5-10')
  Person.create(name: 'Sergio Hiroshi Sakamoto', gender: 'M', alive: true, birth: '1964-10-20',
    description: 'Nasceu na Casa Maternal Leonor Mendes de Barros')
  Person.create(name: 'Sonoi Nakabayashi', gender: 'F', alive: false, birth: '1897-4-14', death: '1981-8-30',
    kanji: '中林 ソノイ', description: 'Hokkaido. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru. Fazenda Santa Laura em Garça.')
  Person.create(name: 'Torajiro Nakabayashi', gender: 'M', alive: false, birth: '1890-6-2', death: '1940-8-16',
    kanji: '中林 虎次郎', description: 'Hokkaido. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru. Fazenda Santa Laura em Garça.')
  Person.create(name: 'Akira Otake', gender: 'M', alive: false, birth: '1934-10-25', death: '1993-7-1',
    kanji: '大竹 明', description: 'Natural de Pirajuí/SP')
  Person.create(name: 'Moyo Yonekubo Otake', gender: 'F', alive: false, birth: '1914-10-14', death: '2005-7-21',
    kanji: '大竹 米窪 もよ', description: 'Entrada em Santos no Brasil em 26 de outubro de 1918 no navio Sanuki Maru')
  Person.create(name: 'Tami Otake', gender: 'F', alive: false, birth: '1864-6-12', death: '1948-10-20',
    kanji: '大竹 たみ', description: 'Gifu. Entrada em Santos no Brasil em 01 de Setembro de 1927 no navio Manila Maru')
  Person.create(name: 'Takeo Yonekubo', gender: 'M', alive: false, birth: '1878-1-12', death: '1955-11-11',
    kanji: '米窪 武雄', description: 'Entrada em Santos no Brasil em 26 de outubro de 1918 no navio Sanuki Maru')
  Person.create(name: 'Yutaka Otake', gender: 'M', alive: true, birth: '1933-1-5', kanji: '大竹 豊')
  Person.create(name: 'Carmen Hisako Nakaji', gender: 'F', alive: false, birth: '1937-6-19', death: '1981-8-7',
    kanji: '久子')
  Person.create(name: 'Iracema Otake dos Santos', gender: 'F', alive: true, birth: '1940-11-21',
    kanji: '和子', description: 'O nome Kazuko foi retirado no casamento')
  Person.create(name: 'Marcio Kazunori Otake', gender: 'M', alive: true, birth: '1963-3-19', kanji: '大竹 一法 マルシオ')
  Person.create(name: 'Regina Harumi Otake Miura', gender: 'F', alive: true, birth: '1974-8-16',
    kanji: '三浦 大竹 春美 へジナ')
  Person.create(name: 'Elson Akio Otake', gender: 'M', alive: true, birth: '1964-10-2', kanji: '大竹 昭夫 エルソン')
  Person.create(name: 'Cristina Akemi Otake', gender: 'F', alive: true, birth: '1983-8-25', kanji: '大竹 明美 クリスチナ')
  Person.create(name: 'Jorge Miura', gender: 'M', alive: false, birth: '1957-12-14', death: '2019-8-1',
    kanji: '三浦 ジョルジェ')
  Person.create(name: 'Helena Ayako Kariatsumari Otake', gender: 'F', alive: true, birth: '1967-9-27',
    kanji: '大竹 狩集 綾子 エレナ')
  Person.create(name: 'Adalberto Santos Braga', gender: 'M', alive: false, birth: '1937-6-25', death: '1994-10-22')
  Person.create(name: 'Sandra Meyre Otake dos Santos Miyahara', gender: 'F', alive: true, birth: '1963-2-19')
  Person.create(name: 'Sergio Roberto Otake dos Santos', gender: 'M', alive: false, birth: '1964-4-13', death: '1976-1-10')
  Person.create(name: 'Catia Regina Otake dos Santos', gender: 'F', alive: false, birth: '1965-4-15', death: '1988-5-27')
  Person.create(name: 'Joaquim Carlos Ranzoni', gender: 'M', alive: true, birth: '1959-10-15')
  Person.create(name: 'Caroline Ranzoni', gender: 'F', alive: true, birth: '1985-9-5')
  Person.create(name: 'Andre Akiyoshi Miyahara', gender: 'M', alive: true, birth: '1974-9-5')
  Person.create(name: 'Andre Akiyoshi Miyahara Jr.', gender: 'M', alive: true, birth: '1999-1-24')
  Person.create(name: 'Sanzan Nakaji', gender: 'M', alive: true, birth: '1936-11-24',
    kanji: '中地三山', description: 'Wakayama. Família Miyamoto (origem). Entrada em Santos no Brasil em 14 de agosto ' \
    'de 1956 no navio Brasil Maru')
  Person.create(name: 'Claudia Sayuri Tokuda', gender: 'F', alive: true, birth: '1963-8-18')
  Person.create(name: 'Cristina Emi Nakaji', gender: 'F', alive: true, birth: '1966-4-2')
  Person.create(name: 'Augusto Tokuda', gender: 'M', alive: true, birth: '1961-8-26')
  Person.create(name: 'Lucas Mitsuharo Tokuda', gender: 'M', alive: true, birth: '1993-11-26')
  Person.create(name: 'Luzinete Carneiro da Silva Otake', gender: 'F', alive: true, birth: '1953-1-25',
    description: 'Natural de Igarapeba - PE')
  Person.create(name: 'Reiko Claudia Otake', gender: 'F', alive: true, birth: '1974-8-14')
  Person.create(name: 'Mayumi Tais Otake', gender: 'F', alive: true, birth: '1979-6-20')
  Person.create(name: 'Joana Gonçalves de Almeida', gender: 'F', alive: false, birth: '1937-2-27', death: '1989-8-26')
  Person.create(name: 'Flávio Antônio Otake', gender: 'M', alive: true, birth: '1958-1-11')
  Person.create(name: 'Fabio Hamilton Otake', gender: 'M', alive: true, birth: '1963-2-14')
  Person.create(name: 'Eiko Cristina Otake', gender: 'F', alive: false, birth: '1959-9-22', death: '1995-1-30')
  Person.create(name: 'Francisco Fernando Otake', gender: 'M', alive: true, birth: '1968-5-26')
  Person.create(name: 'Tikashi Sakamoto', gender: 'M', alive: false, kanji: '坂本 近至')
  Person.create(name: 'Asa Yamazaki', gender: 'F', alive: false, birth: '1914-2-28', death: '1986-12-28',
    kanji: 'あさ', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Tani Yamazaki', gender: 'F', alive: false, birth: '1916-2-10',
    kanji: 'たに', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Rikizo Sakamoto', gender: 'M', alive: false, birth: '1920-11-28', death: '1990-12-13',
    kanji: '坂本 力三', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila ' \
    'Maru. Faleceu em Diadema/SP')
  Person.create(name: 'Yoshio Sakamoto', gender: 'M', alive: false, birth: '1923-3-30', death: '2003-6-11',
    kanji: '坂本 善夫', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Toshio Sakamoto', gender: 'M', alive: false, birth: '1926-5-14', death: '1958-7-31',
    kanji: '坂本 俊雄', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila ' \
    'Maru. Morreu na obra de construção da av 9 de Julho.')
  Person.create(name: 'Michio Sakamoto', gender: 'M', alive: true, birth: '1928-5-5',
    kanji: '坂本 通郎', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Yasujiro Nakabayashi', gender: 'M', alive: false, birth: '1916-7-1',
    kanji: '中林 安治郎', description: 'Hokkaido. Campinas. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no ' \
    'navio Montevideo Maru')
  Person.create(name: 'Tiyo', gender: 'F', alive: false)
  Person.create(name: 'Kiyo', gender: 'F', alive: false)
  Person.create(name: 'Takeo Nakabayashi', gender: 'M', alive: false, birth: '1921-8-15', death: '2019-2-13',
    kanji: '中林 武雄', description: 'Hokkaido. Penha. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru')
  Person.create(name: 'Hideo Nakabayashi', gender: 'M', alive: true, birth: '1924-6-14',
    kanji: '中林 秀夫', description: 'Hokkaido. Carrão. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru')
  Person.create(name: 'Shokiti Nakabayashi', gender: 'M', alive: false, birth: '1927-1-24', death: '2013-10-15',
    kanji: '中林 庄吉', description: 'Hokkaido. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru')
  Person.create(name: 'Miyo Nakabayashi Missu', gender: 'F', alive: false, birth: '1929-8-20', death: '2017-6-20',
    kanji: '美代', description: 'Hokkaido. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru')
  Person.create(name: 'Nobu Shimada', gender: 'F', alive: true, birth: '1934-7-10',
    kanji: 'ノブ', description: 'Hokkaido. Entrada em Santos no Brasil em 28 de fevereiro de 1937 no navio ' \
    'Montevideo Maru')
  Person.create(name: 'Hatsue Tanaka', gender: 'F', alive: true, birth: '1938-5-1')
  Person.create(name: 'Yaso Omi', gender: 'M', alive: true, birth: '1945-2-20', description: 'Natural de Piratininga')
  Person.create(name: 'Ricardo Sakamoto Omi', gender: 'M', alive: true, birth: '1985-11-29')
  Person.create(name: 'Juliana Sakamoto Omi', gender: 'F', alive: true, birth: '1988-4-19')
  Person.create(name: 'Keisso Ueno', gender: 'M', alive: true, birth: '1947-8-18', description: 'Roberto')
  Person.create(name: 'Andre Toshio Ueno', gender: 'M', alive: true, birth: '1985-4-16')
  Person.create(name: 'Eduardo Mitio Ueno', gender: 'M', alive: true, birth: '1981-10-9')
  Person.create(name: 'Cristina Sayuri Ueno', gender: 'F', alive: true, birth: '1980-2-21')
  Person.create(name: 'Lucia Fernandes Mello Sakamoto', gender: 'F', alive: true, birth: '1955-4-15',
    description: 'Natural de Ituiutaba/MG')
  Person.create(name: 'Mariana Mieko Sakamoto', gender: 'F', alive: true, birth: '1981-2-4')
  Person.create(name: 'Daniel Hideki Sakamoto', gender: 'M', alive: true, birth: '1983-5-19')
  Person.create(name: 'Thiago Tomio Sakamoto', gender: 'M', alive: true, birth: '1985-12-17')
  Person.create(name: 'Silvia Aparecida de Brito Sakamoto', gender: 'F', alive: false, birth: '1946-9-6')
  Person.create(name: 'Ana Rita Sakamoto', gender: 'F', alive: true, birth: '1973-8-17')
  Person.create(name: 'Roberta Maria Sakamoto Thomazelli', gender: 'F', alive: true, birth: '1975-12-3')
  Person.create(name: 'Hetsuko Sakamoto', gender: 'F', alive: true, birth: '1941-6-14',
    description: 'Natural de Presidente Venceslau/SP. Registro de nascimento no dia 20 de agosto.')
  Person.create(name: 'Rodrigo Eiji Sakamoto', gender: 'M', alive: true, birth: '1976-11-5')
  Person.create(name: 'Jenifer Mori', gender: 'F', alive: true)
  Person.create(name: 'Carolina Yukari Sakamoto', gender: 'F', alive: true, birth: '1995-10-9')
  Person.create(name: 'Flavia Otake', gender: 'F', alive: true)
  Person.create(name: 'Fabiano Otake', gender: 'M', alive: true)
  Person.create(name: 'Igor Otake', gender: 'M', alive: true)
  Person.create(name: 'Ana Maria da Cruz', gender: 'F', alive: true)
  Person.create(name: 'Fabiana da Cruz Otake', gender: 'F', alive: true, birth: '1987-7-3')
  Person.create(name: 'Juliana da Cruz Otake', gender: 'F', alive: true, birth: '1989-2-19')
  Person.create(name: 'Fabio da Cruz Otake', gender: 'M', alive: true, birth: '1990-3-17')
  Person.create(name: 'Felipe da Cruz Otake', gender: 'M', alive: true, birth: '1991-10-20')
  Person.create(name: 'Fatima Maria da Cruz', gender: 'F', alive: true, birth: '1994-6-26',
    description: 's/ Otake no nome estah sendo adotada por outra família')
  Person.create(name: 'Geraldo Manoel da Silva', gender: 'M', alive: true)
  Person.create(name: 'Miriam Otake de Oliveira', gender: 'F', alive: true)
  Person.create(name: 'Eliane', gender: 'F', alive: true)
  Person.create(name: 'Amanda Takahashi Otake', gender: 'F', alive: true, birth: '1997-10-21')
  Person.create(name: 'Lucas Takahashi Otake', gender: 'M', alive: true, birth: '2000-4-1', death: '2009-9-8',
    description: 'Faleceu de leucemia')
  Person.create(name: 'Marta Regina Sakamoto', gender: 'F', alive: true, birth: '1980-1-24')
  Person.create(name: 'Hifumi Akiyoshi', gender: 'F', alive: false, birth: '1922-1-13',
    description: 'Foto : Shigeo, Moyo, Hifumi e Kimiko')
  Person.create(name: 'Shigeo Yonekubo', gender: 'M', alive: false, birth: '1919-7-7', death: '1970-11-13',
    kanji: '米窪 繁雄')
  Person.create(name: 'Takashi Yonekubo', gender: 'M', alive: false, birth: '1921-2-12', death: '1983-12-30',
    kanji: '米窪 孝', description: 'No cemitério do Araça o nome consta como Takeshi Yonekubo')
  Person.create(name: 'Masayuki Akiyoshi', gender: 'M', alive: false, birth: '1912-8-1',
    kanji: '秋吉正行', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Roberto Yonekubo', gender: 'M', alive: true)
  Person.create(name: 'Rosangela', gender: 'F', alive: true)
  Person.create(name: 'Kuniko', gender: 'F', alive: true)
  Person.create(name: 'Haruko', gender: 'F', alive: true, description: 'Foto : Haruko e Kuniko')
  Person.create(name: 'Miyeko', gender: 'F', alive: true, description: 'Foto : Shigeo, Kimiko, Miyeko, Haruko e Kuniko')
  Person.create(name: 'Reiko', gender: 'F', alive: true)
  Person.create(name: 'Mitsuko', gender: 'F', alive: true)
  Person.create(name: 'Sachiko', gender: 'F', alive: true)
  Person.create(name: 'Toshio Akiyoshi', gender: 'M', alive: true)
  Person.create(name: 'Mitsuo Akiyoshi', gender: 'M', alive: false, death: '2004-10-22')
  Person.create(name: 'Masao Akiyoshi', gender: 'M', alive: true)
  Person.create(name: 'Isao Akiyoshi', gender: 'M', alive: true)
  Person.create(name: 'Tsunesaburo Murase', gender: 'M', alive: false, death: '1963-11-8')
  Person.create(name: 'Take (Murase) Otake', gender: 'F', alive: false, birth: '1901-7-20', death: '1928-6-18',
    kanji: '大竹 たけ', description: 'Gifu. Entrada em Santos no Brasil em 01 de Setembro de 1927 no navio Manila Maru')
  Person.create(name: 'Yoshiaki Murase', gender: 'M', alive: false, birth: '1931-1-1', death: '2003-1-1',
    kanji: '村瀬 義秋', description: '5 anos + velho q Minoru. Conhecido somente o ano de nascimento e falecimento. Dia ' \
    'e mês chutado.')
  Person.create(name: 'Fusako Ota', gender: 'F', alive: true, birth: '1923-1-1',
    kanji: '太田 ふさ子', description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Minoru (Murase) Otake', gender: 'M', alive: false, birth: '1925-9-2',
    kanji: '大竹 實', description: 'Gifu. Entrada em Santos no Brasil em 01 de Setembro de 1927 no navio Manila Maru.')
  Person.create(name: 'Hiromi Otake Henna', gender: 'F', alive: true, birth: '1949-10-21')
  Person.create(name: 'Yuriko Otake Perina', gender: 'F', alive: true, birth: '1952-1-19')
  Person.create(name: 'Tsuneo Henna', gender: 'M', alive: true, birth: '1945-2-25')
  Person.create(name: 'Alexandra Henna Abussanra', gender: 'F', alive: true, birth: '1970-4-2')
  Person.create(name: 'Daniela Henna', gender: 'F', alive: true, birth: '1975-3-22')
  Person.create(name: 'Carla Henna', gender: 'F', alive: true, birth: '1978-5-20')
  Person.create(name: 'Jose Elias Abussanra', gender: 'M', alive: true)
  Person.create(name: 'Bruno Henna Abussanra', gender: 'M', alive: true, birth: '1993-1-21')
  Person.create(name: 'Marcos Perina', gender: 'M', alive: true)
  Person.create(name: 'Amanda Perina', gender: 'F', alive: true, birth: '1978-6-4')
  Person.create(name: 'Melissa Perina', gender: 'F', alive: true, birth: '1980-3-12')
  Person.create(name: 'Asakichi Yonekubo', gender: 'M', alive: false,
    kanji: '米窪 朝吉', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no navio ' \
    'Buenos Aires Maru')
  Person.create(name: 'Yatsue Yonekubo', gender: 'F', alive: false, birth: '1895-6-2', death: '1990-7-8',
    kanji: '米窪 や津枝', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no navio ' \
    'Buenos Aires Maru. Faleceu em Marília/SP')
  Person.create(name: 'Tadanori Yonekubo', gender: 'M', alive: false, birth: '1921-5-25',
    kanji: '米窪 忠教', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no navio ' \
    'Buenos Aires Maru')
  Person.create(name: 'Morimasa Yonekubo', gender: 'M', alive: true, birth: '1930-5-25',
    kanji: '米窪 守正', description: 'Nagano. Marília. Entrada em Santos no Brasil em 02 de agosto de 1933 ' \
    'no navio Buenos Aires Maru')
  Person.create(name: 'Masato Yonekubo', gender: 'M', alive: false, birth: '1932-3-10', death: '1956-4-18',
    kanji: '米窪 真人', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no navio ' \
    'Buenos Aires Maru. Faleceu em Bandeirantes/PR')
  Person.create(name: 'Asako Yonekubo', gender: 'F', alive: true, birth: '1919-12-16',
    kanji: '米窪 朝子', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no ' \
    'navio Buenos Aires Maru')
  Person.create(name: 'Ayako Yonekubo', gender: 'F', alive: true, birth: '1925-9-29',
    kanji: '米窪 朝や子', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no ' \
    'navio Buenos Aires Maru')
  Person.create(name: 'Shoko Yonekubo', gender: 'F', alive: true, birth: '1927-11-11',
    kanji: '米窪 昭子', description: 'Nagano. Entrada em Santos no Brasil em 02 de agosto de 1933 no ' \
    'navio Buenos Aires Maru')
  Person.create(name: 'Uda Kokichi', gender: 'M', alive: true)
  Person.create(name: 'Leticia Miwa Tokuda', gender: 'F', alive: true, birth: '1996-12-3')
  Person.create(name: 'Sem cadastro Eiko', gender: 'M', alive: true)
  Person.create(name: 'Tatiane Cristina Otake', gender: 'F', alive: true, birth: '1977-10-21')
  Person.create(name: 'Mariana Henna Abussanra', gender: 'F', alive: true, birth: '1996-10-20')
  Person.create(name: 'Tetsuno Ono', gender: 'F', alive: false, birth: '1899-12-20', death: '1983-11-12',
    kanji: '大野テツノ', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Sakuichi Ono', gender: 'M', alive: false, birth: '1900-2-22', death: '1957-7-31',
    kanji: '大野作市', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Tatiana Mitie Miura', gender: 'F', alive: true, birth: '2002-6-4', kanji: '三浦 巳智恵 タチアナ')
  Person.create(name: 'Cho Otake', gender: 'M', alive: false, birth: '1905-12-10', death: '1989-11-12',
    kanji: '大竹 長', description: 'Partida de Gifu em 7/7/1927 e entrada em Santos no Brasil em 01 de Setembro de 1927 ' \
    'no navio Manila Maru. Com a esposa Yoshio, a mãe Tami, a irmã Take e o sobrinho Minoru.')
  Person.create(name: 'Omine Yonekubo', gender: 'F', alive: false, birth: '1889-3-3',
    kanji: '米窪 をみね', description: 'Moyo tinha 12 anos qdo ela faleceu. Entrada em Santos no Brasil em 26 de outubro ' \
    'de 1918 no navio Sanuki Maru')
  Person.create(name: 'Hideko Nishida', gender: 'F', alive: true)
  Person.create(name: 'Mariko Ikeda', gender: 'F', alive: true, birth: '1926-1-1',
    description: 'Desconhecido dia e mes de nascimento')
  Person.create(name: 'Marie', gender: 'F', alive: true, description: 'Foto : set/1957')
  Person.create(name: 'Satie', gender: 'F', alive: true, description: 'Foto : set/1957')
  Person.create(name: 'Keiko', gender: 'F', alive: true)
  Person.create(name: 'Tiemi', gender: 'F', alive: true)
  Person.create(name: 'Fusako Nagashima', gender: 'F', alive: false, birth: '1916-7-21', death: '1992-12-25',
    kanji: '房子', description: 'Entrada em Santos no Brasil em 26 de outubro de 1918 no navio Sanuki Maru. Faleceu ' \
    'em Piracicaba/SP')
  Person.create(name: 'Fumio Nagashima', gender: 'M', alive: false)
  Person.create(name: 'Helio Nagashima', gender: 'M', alive: true)
  Person.create(name: 'Rosa', gender: 'F', alive: true)
  Person.create(name: 'Helena', gender: 'F', alive: true)
  Person.create(name: 'Maria', gender: 'F', alive: true)
  Person.create(name: 'Tereza Simonaka', gender: 'F', alive: true)
  Person.create(name: 'Mao Yonekubo', gender: 'F', alive: false, birth: '1890-1-13', death: '1963-4-23')
  Person.create(name: 'Jonataro Shimodairo', gender: 'M', alive: false)
  Person.create(name: 'Akira Nishida', gender: 'M', alive: false)
  Person.create(name: 'Goro Ikeda', gender: 'M', alive: true, birth: '1920-12-25',
    kanji: '池田五郎', description: 'Osaka. Entrada em Santos no Brasil em 31 de julho de 1924 no navio Canada Maru')
  Person.create(name: 'Shizuko Yonekubo', gender: 'F', alive: true)
  Person.create(name: 'Kimiko Yonekubo', gender: 'F', alive: false, birth: '1924-8-20', death: '1975-12-24',
    description: 'Joana Yonekubo')
  Person.create(name: 'Yasutaro Otake', gender: 'M', alive: false, description: 'Yassujiro?')
  Person.create(name: 'Kazue Otake', gender: 'F', alive: true, birth: '1930-12-3',
    kanji: '大野和惠', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Elizete Volpe Otake', gender: 'F', alive: true)
  Person.create(name: 'Sandra Regina Otake', gender: 'F', alive: true, birth: '1967-9-20')
  Person.create(name: 'Yoshio Otake', gender: 'F', alive: false, birth: '1904-3-30',
    kanji: '大竹 よしお', description: 'Gifu. Entrada em Santos no Brasil em 01 de Setembro de 1927 no navio Manila Maru')
  Person.create(name: 'Tomihide Sakamoto', gender: 'M', alive: false, birth: '1930-4-19', death: '1932-7-29',
    kanji: '坂本 富英', description: 'Yamanashi. Entrada em Santos no Brasil em 27 de junho de 1932 no navio Manila Maru')
  Person.create(name: 'Munenawo Yamazaki', gender: 'M', alive: false, birth: '1910-6-22', death: '1967-10-27',
    kanji: '山崎 宗直', description: 'Toyama. Entrada em Santos no Brasil em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Soichiro Yamazaki', gender: 'M', alive: false, birth: '1907-4-10', death: '1969-6-14',
    kanji: '山崎 宗一郎', description: 'Tokyo. Entrada em Santos no Brasil em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Yoshie Sakamoto', gender: 'F', alive: false, birth: '1925-2-7', death: '1961-2-16',
    kanji: '近藤 芳江', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru')
  Person.create(name: 'Yasuo Shimada', gender: 'M', alive: false, birth: '1929-9-4', death: '1972-1-25')
  Person.create(name: 'Mikiji Missu', gender: 'M', alive: true, birth: '1928-8-4',
    kanji: '翠幹冶', description: 'Gifu. Entrada em Santos no Brasil em 22 de maio de 1934 no navio Arizona Maru')
  Person.create(name: 'Yuriko Nakabayashi', gender: 'F', alive: true)
  Person.create(name: 'Hiroko Nakabayashi', gender: 'F', alive: true, birth: '1928-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Ernesto Kazuo Shimada', gender: 'M', alive: true, birth: '1959-6-27')
  Person.create(name: 'Rose Talma Shimada', gender: 'F', alive: true)
  Person.create(name: 'Guilherme Ken Shimada', gender: 'M', alive: true, birth: '1994-9-28')
  Person.create(name: 'Fernanda Akemi Shimada', gender: 'F', alive: true, birth: '1996-10-13')
  Person.create(name: 'Claudio Tsuguio Shimada', gender: 'M', alive: true, birth: '1962-9-30')
  Person.create(name: 'Clara Harue Shimada', gender: 'F', alive: true)
  Person.create(name: 'Fabio Yasuo Shimada', gender: 'M', alive: true, birth: '1982-5-16')
  Person.create(name: 'Juliana Tiemi Shimada', gender: 'F', alive: true, birth: '1984-7-27')
  Person.create(name: 'Ivan Goro Shimada', gender: 'M', alive: true, birth: '1998-4-25')
  Person.create(name: 'Ines Souza Pereira', gender: 'F', alive: true)
  Person.create(name: 'Andre Katsuhiro Pereira Omi', gender: 'M', alive: true, birth: '1973-7-13')
  Person.create(name: 'Maria Aparecida Azevedo', gender: 'F', alive: true, birth: '1967-4-15', description: 'Mara')
  Person.create(name: 'Barbara Azevedo Omi', gender: 'F', alive: true, birth: '1995-4-17')
  Person.create(name: 'Vinicius Azevedo Omi', gender: 'M', alive: true, birth: '2002-1-21')
  Person.create(name: 'Tadashi Tanaka', gender: 'M', alive: true, birth: '1931-9-10',
    kanji: '田中 正', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Kazuko Tanaka', gender: 'F', alive: true)
  Person.create(name: 'Leonardo Akira Tanaka', gender: 'M', alive: true)
  Person.create(name: 'Luriko Tanaka', gender: 'F', alive: true)
  Person.create(name: 'Helena Tanaka', gender: 'F', alive: true)
  Person.create(name: 'Jorge Kotaro Misu', gender: 'M', alive: true, birth: '1957-6-3')
  Person.create(name: 'Leonardo Yukihiro Misu', gender: 'M', alive: true, birth: '1960-8-1')
  Person.create(name: 'Emilia Kimie Misu', gender: 'F', alive: false, birth: '1958-4-4')
  Person.create(name: 'Margarida Hiromi Misu Nakagawa', gender: 'F', alive: true, birth: '1964-10-6')
  Person.create(name: 'Helena Uemura Misu', gender: 'F', alive: true, birth: '1957-12-21')
  Person.create(name: 'Áurea Hisae Misu', gender: 'F', alive: true, birth: '1986-1-5')
  Person.create(name: 'Sem cadastro Yukihiro', gender: 'F', alive: true)
  Person.create(name: 'Carlos Nakagawa', gender: 'M', alive: true, birth: '1968-1-11')
  Person.create(name: 'Cintia Yumi Nakagawa', gender: 'F', alive: true, birth: '1990-12-7')
  Person.create(name: 'Cristina Thiemy Nakagawa', gender: 'F', alive: true, birth: '1997-3-25')
  Person.create(name: 'Marcio Kendy Nakagawa', gender: 'M', alive: true, birth: '2000-3-14')
  Person.create(name: 'Vaildo Hideyuki Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Hideyuki', gender: 'F', alive: true)
  Person.create(name: 'Valdir Hidenari Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Hidenari', gender: 'F', alive: true)
  Person.create(name: 'Regina Etsuko Nakabayashi', gender: 'F', alive: true, kanji: '中林 エツ子 へジナ')
  Person.create(name: 'Rosemary Yoko Nakabayashi', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Rosemary', gender: 'M', alive: true)
  Person.create(name: 'Julio Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Shizue Nakabayashi', gender: 'F', alive: true)
  Person.create(name: 'Luisa Yukie Nakabayashi', gender: 'F', alive: true, kanji: '中林 幸枝 ルイザ')
  Person.create(name: 'Takeshi Nakabayashi', gender: 'M', alive: false, description: 'Morreu de difteria')
  Person.create(name: 'Takemi Nakabayashi', gender: 'M', alive: false, description: 'Morreu de difteria')
  Person.create(name: 'Yoko Kondo', gender: 'F', alive: true)
  Person.create(name: 'Wilson Eidi Sakamoto', gender: 'M', alive: true, birth: '1957-10-7', description: 'Dracena')
  Person.create(name: 'Nelson Takeshi Sakamoto', gender: 'M', alive: true, birth: '1958-11-2', description: 'Dracena')
  Person.create(name: 'Alice Mizue Sakamoto', gender: 'F', alive: true)
  Person.create(name: 'Milton Tsuyoshi Sakamoto', gender: 'M', alive: true)
  Person.create(name: 'Sérgio Koji Sakamoto', gender: 'M', alive: true)
  Person.create(name: 'Tomi Sekito Sakamoto', gender: 'F', alive: true, birth: '1931-6-12', description: 'Iguape/SP')
  Person.create(name: 'Emiko', gender: 'F', alive: true)
  Person.create(name: 'Seyishi Sakamoto', gender: 'M', alive: true, birth: '1945-6-1')
  Person.create(name: 'Luiz Riyoji Sakamoto', gender: 'M', alive: true, birth: '1947-10-1', description: 'Oswaldo Cruz')
  Person.create(name: 'Moriyaki Sakamoto', gender: 'M', alive: true)
  Person.create(name: 'Teruko Maruo Sakamoto', gender: 'F', alive: true, birth: '1924-8-4', description: 'Fukuoka')
  Person.create(name: 'Haruko Fujisawa', gender: 'F', alive: true)
  Person.create(name: 'Marie Sakamoto', gender: 'F', alive: true, birth: '1955-3-12', description: 'Panorama')
  Person.create(name: 'Osamu Sakamoto', gender: 'M', alive: true)
  Person.create(name: 'Junji Sakamoto', gender: 'M', alive: true, birth: '1960-6-5', description: 'Panorama')
  Person.create(name: 'Satoru Sakamoto', gender: 'M', alive: true, birth: '1957-6-6', description: 'Panorama')
  Person.create(name: 'Hiroko Sakamoto', gender: 'F', alive: true, birth: '1963-9-12', description: 'Panorama')
  Person.create(name: 'Elina Sakamoto', gender: 'F', alive: true)
  Person.create(name: 'Atsuko Yamamoto', gender: 'F', alive: true, birth: '1966-5-7', description: 'Panorama')
  Person.create(name: 'Soji Yamazaki', gender: 'M', alive: true)
  Person.create(name: 'Emiko', gender: 'F', alive: true)
  Person.create(name: 'Emi', gender: 'F', alive: true)
  Person.create(name: 'Fabio Eiji Yamazaki', gender: 'M', alive: true)
  Person.create(name: 'Marie Sato', gender: 'F', alive: true, birth: '1952-8-6', description: 'São Paulo/SP')
  Person.create(name: 'Nelson Sato', gender: 'M', alive: true)
  Person.create(name: 'Wiliam Hiroshi Sato', gender: 'M', alive: true)
  Person.create(name: 'Wellington Hitoshi Sato', gender: 'M', alive: true)
  Person.create(name: 'Tomoko Yoshii Yamazaki', gender: 'F', alive: true, birth: '1934-8-21')
  Person.create(name: 'Masaaki Yoshii', gender: 'M', alive: false, birth: '1932-8-18', death: '1997-11-26')
  Person.create(name: 'Edson Yoshii', gender: 'M', alive: true, birth: '1961-4-30')
  Person.create(name: 'Rosemaly Naomi Tabuti', gender: 'F', alive: true, birth: '1969-2-5')
  Person.create(name: 'Naomatsu Yamazaki', gender: 'M', alive: true, birth: '1936-2-5',
    kanji: '直勝', description: 'Guarujá/SP. Naokatsu')
  Person.create(name: 'Ayaka Yamazaki', gender: 'F', alive: false, birth: '1941-4-21', death: '1992-11-27', description: 'Descalvado')
  Person.create(name: 'Reimi Yamazaki', gender: 'F', alive: true, birth: '1969-8-2')
  Person.create(name: 'Meire Yamazaki', gender: 'F', alive: true)
  Person.create(name: 'Erica Yamazaki', gender: 'F', alive: true)
  Person.create(name: 'Satoe Hatori', gender: 'F', alive: true, birth: '1938-1-10')
  Person.create(name: 'Shinzo Hatori', gender: 'M', alive: false, birth: '1933-3-26', death: '1998-3-27')
  Person.create(name: 'Eduardo Masaro Hatori', gender: 'M', alive: true)
  Person.create(name: 'Fabio Katsumi Hatori', gender: 'M', alive: true)
  Person.create(name: 'Elisa Mariko Hosaki', gender: 'F', alive: true, birth: '1962-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sueli Hatori', gender: 'F', alive: true, birth: '1964-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sakiko Nakamura', gender: 'F', alive: true, birth: '1941-12-8')
  Person.create(name: 'Mitio Nakamura', gender: 'M', alive: false, birth: '1935-1-1', death: '1991-3-1',
    description: 'Conhecido somente o ano de nascimento e falecimento. Dia e mês chutado.')
  Person.create(name: 'Gilberto Shigeru Nakamura', gender: 'M', alive: true)
  Person.create(name: 'Elisabeth Nakamura Kagohara', gender: 'F', alive: true, birth: '1971-1-24')
  Person.create(name: 'Janete Asami Sato', gender: 'F', alive: true)
  Person.create(name: 'Fumi Nakabayashi', gender: 'F', alive: false, birth: '1921-5-28',
    kanji: '田中 フミ', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Toshie Barros', gender: 'F', alive: true,
    description: 'Foto : Miyo, Nobu, Takashi, Takeo, Toshio Tanaka, Marta Tomiko, Tetsuo, Cristina Kazue, ' \
    'Satiye, Masao e Toshie')
  Person.create(name: 'Cristina Kazue Sasaki', gender: 'F', alive: true,
    description: 'Foto : Miyo, Nobu, Takashi, Takeo, Toshio Tanaka, Marta Tomiko, Tetsuo, Cristina Kazue, ' \
    'Satiye, Masao e Toshie')
  Person.create(name: 'Marta Tomiko Rossi', gender: 'F', alive: false,
    description: 'Foto : Miyo, Nobu, Takashi, Takeo, Toshio Tanaka, Marta Tomiko, Tetsuo, Cristina Kazue, ' \
    'Satiye, Masao e Toshie')
  Person.create(name: 'Alice Shizue Viana', gender: 'F', alive: true)
  Person.create(name: 'Jorge Yasunori Nakabayashi', gender: 'M', alive: true, kanji: '中林 保則 ジョルジェ')
  Person.create(name: 'Dirceu Mamoru Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Lincoln Satoru Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Kazue Sasaki', gender: 'F', alive: false)
  Person.create(name: 'Miyoko Koshimizu', gender: 'F', alive: true, birth: '1951-3-26')
  Person.create(name: 'Jose Francisco Brides', gender: 'M', alive: true)
  Person.create(name: 'Rodrigo Koshimizu', gender: 'M', alive: true, birth: '1981-7-6')
  Person.create(name: 'Fernanda Koshimizu', gender: 'F', alive: true, birth: '1983-3-6')
  Person.create(name: 'Francisco Nobuo Tabuti', gender: 'M', alive: true, birth: '1964-2-23')
  Person.create(name: 'Sem cadastro Yonekubo 2', gender: 'F', alive: false)
  Person.create(name: 'Sem cadastro Yonekubo 1', gender: 'M', alive: false)
  Person.create(name: 'Jiro Tanaka', gender: 'M', alive: false, birth: '1894-4-23',
    kanji: '田中 次郎', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Miki Tanaka', gender: 'F', alive: false, birth: '1891-3-12',
    kanji: '田中 美き', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Pety', gender: 'P', alive: false, birth: '1971-8-1')
  Person.create(name: 'Roberto Akio Yoshii', gender: 'M', alive: true, birth: '1958-10-24',
    description: 'Registrado no dia 25 de outubro pois o pai não gostava do numero 24')
  Person.create(name: 'Mitiko Yoshii', gender: 'F', alive: true, birth: '1958-4-1',
    description: 'Conhecido somente o ano e mês de nascimento. Dia chutado.')
  Person.create(name: 'Renata Yumi Yoshii', gender: 'F', alive: true, birth: '1992-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Emilia Yoshii Nishimura', gender: 'F', alive: true, birth: '1960-4-22')
  Person.create(name: 'Roberto Nishimura', gender: 'M', alive: true)
  Person.create(name: 'Fernando Nishimura', gender: 'M', alive: true, birth: '1990-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Henrique Nishimura', gender: 'M', alive: true, birth: '1993-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Rosana Goncalves Yoshii', gender: 'F', alive: true)
  Person.create(name: 'Tatiana Goncalves Yoshii', gender: 'F', alive: true, birth: '1982-11-24')
  Person.create(name: 'Akemi Kinoshita', gender: 'F', alive: true, birth: '1947-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sem cadastro Erica', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Meire', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Elisa', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Katsumi', gender: 'F', alive: true)
  Person.create(name: 'Masaki Ogawa', gender: 'M', alive: true)
  Person.create(name: 'Helio Sato', gender: 'M', alive: true)
  Person.create(name: 'Tiago Sato', gender: 'M', alive: true)
  Person.create(name: 'Bruno Sato', gender: 'M', alive: true)
  Person.create(name: 'Jorge Kagohara', gender: 'M', alive: true)
  Person.create(name: 'Karina Kagohara', gender: 'F', alive: true)
  Person.create(name: 'Larissa Kagohara', gender: 'F', alive: true)
  Person.create(name: 'Sato Yamazaki', gender: 'F', alive: true)
  Person.create(name: 'Sobei Yamazaki', gender: 'M', alive: true)
  Person.create(name: 'Roberto Itiro Yonekubo', gender: 'M', alive: false, birth: '1954-2-1', death: '1954-2-6')
  Person.create(name: 'Sumiko Murase', gender: 'F', alive: false, death: '1994-1-1',
    kanji: '村瀬 すみ子', description: 'Conhecido somente o ano de falecimento. Dia e mês chutado.')
  Person.create(name: 'Flora Uemoto Yonekubo', gender: 'F', alive: true, birth: '1939-1-20')
  Person.create(name: 'Sem cadastro Nagashima', gender: 'F', alive: true)
  Person.create(name: 'Suzi', gender: 'P', alive: false, birth: '1971-8-1', death: '1983-6-1',
    description: 'Adotada no Nippon Country Club em Arujá')
  Person.create(name: 'Tibi', gender: 'P', alive: false, birth: '1972-6-1', death: '1974-9-1')
  Person.create(name: 'Marcelo Mitsuo Misu', gender: 'M', alive: true, birth: '1987-5-8')
  Person.create(name: 'Marcos Haruo Misu', gender: 'M', alive: true, birth: '1988-10-6')
  Person.create(name: 'Sada Otake', gender: 'M', alive: false)
  Person.create(name: 'Hatsu Takada', gender: 'F', alive: false, kanji: 'ハツ')
  Person.create(name: 'Shunji Murase', gender: 'M', alive: true, kanji: '村瀬 俊二')
  Person.create(name: 'Osamu Murase', gender: 'M', alive: true, kanji: '村瀬 修')
  Person.create(name: 'Shigeki Murase', gender: 'M', alive: true, kanji: '村瀬 繁樹')
  Person.create(name: 'Tsuya Usui', gender: 'F', alive: false, birth: '1889-1-1', death: '1958-1-1',
    kanji: '臼井 ツヤ', description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Shinajirou Usui', gender: 'M', alive: false, birth: '1888-1-1', death: '1965-1-1',
    kanji: '臼井 科次郎', description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Toru Usui', gender: 'M', alive: true, birth: '1919-10-17', death: '2013-5-17', kanji: '臼井 徹')
  Person.create(name: 'Misao Usui', gender: 'F', alive: true, birth: '1923-5-3', death: '2020-6-24', kanji: '臼井 操')
  Person.create(name: 'Kenichi Usui', gender: 'M', alive: true, birth: '1948-6-8', kanji: '臼井 健一')
  Person.create(name: 'Naoki Usui', gender: 'M', alive: true, birth: '1950-1-4', kanji: '臼井 直樹')
  Person.create(name: 'Sumako Narita', gender: 'F', alive: true, birth: '1953-2-7', kanji: '臼井 須磨子')
  Person.create(name: 'Daiki Usui', gender: 'M', alive: true, birth: '1981-12-31', kanji: '臼井 大貴')
  Person.create(name: 'Chie Usui', gender: 'F', alive: true, birth: '1983-11-6', kanji: '臼井 千恵')
  Person.create(name: 'Yasuyo Kondoh', gender: 'F', alive: true, birth: '1965-10-22', kanji: '臼井 恭代')
  Person.create(name: 'Sadako Usui', gender: 'F', alive: true, birth: '1924-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Shogo Usui', gender: 'M', alive: true, birth: '1930-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Hideo Usui', gender: 'M', alive: false, death: '1982-1-1',
    description: 'Conhecido somente o ano de falecimento. Dia e mês chutado.')
  Person.create(name: 'Juji Usui', gender: 'M', alive: true, birth: '1927-1-1',
    kanji: '臼井 重治', description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Kazuko Kishi', gender: 'F', alive: true, birth: '1935-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yoshihiro Usui', gender: 'M', alive: true, birth: '1953-1-1',
    kanji: '臼井 克裕', description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sem cadastro Yoshihiro', gender: 'F', alive: true)
  Person.create(name: 'Kazuo Kamiya', gender: 'M', alive: false, birth: '1925-1-1', death: '1995-1-1',
    description: 'Conhecido somente o ano de nascimento e falecimento. Dia e mês chutado.')
  Person.create(name: 'Keiko Kamiya', gender: 'F', alive: true, birth: '1955-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sem cadastro Outa 2', gender: 'M', alive: true)
  Person.create(name: 'Outa Usui', gender: 'M', alive: true)
  Person.create(name: 'Tetsuhiro Honjoh', gender: 'M', alive: true, birth: '1961-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yumi Honjoh', gender: 'F', alive: true, birth: '1986-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yamato Honjoh', gender: 'F', alive: true, birth: '1986-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Tsuyako Fujimoto', gender: 'F', alive: true, birth: '1932-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Masaki Usui', gender: 'M', alive: true, birth: '1952-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Masao Simonaka', gender: 'M', alive: true)
  Person.create(name: 'Itsuo Otake', gender: 'M', alive: false)
  Person.create(name: 'Kazuko Otake', gender: 'F', alive: false)
  Person.create(name: 'Kuwa Hashimoto', gender: 'F', alive: false)
  Person.create(name: 'Nobukichi Usui', gender: 'M', alive: false, death: '1907-1-1',
    description: 'Conhecido somente o ano de falecimento. Dia e mês chutado.')
  Person.create(name: 'Mikie Gotoh', gender: 'F', alive: false, death: '1979-1-1',
    description: 'Conhecido somente o ano de falecimento. Dia e mês chutado.')
  Person.create(name: 'Toshihiro Usui', gender: 'M', alive: true, birth: '1956-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Chikage Nishihara', gender: 'F', alive: true, birth: '1960-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yuh Usui', gender: 'M', alive: true, birth: '1988-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Mizuki Usui', gender: 'F', alive: true, birth: '1991-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Mami Usui', gender: 'F', alive: true, birth: '1957-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Noriko Murase', gender: 'F', alive: true)
  Person.create(name: 'Masumi Murase', gender: 'F', alive: true)
  Person.create(name: 'Rueko Murase', gender: 'F', alive: true)
  Person.create(name: 'Ken Otake', gender: 'F', alive: false, birth: '1897-1-1', death: '1988-1-1',
    description: 'Conhecido somente o ano de nascimento e falecimento. Dia e mês chutado.')
  Person.create(name: 'Yoshitaro Konno', gender: 'M', alive: false, birth: '1896-1-1', death: '1982-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Masako Konno', gender: 'F', alive: true, birth: '1922-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Keizo Satoh', gender: 'M', alive: false, birth: '1922-1-1', death: '2003-1-1',
    description: 'Conhecido somente o ano de nascimento e falecimento. Dia e mês chutado.')
  Person.create(name: 'Sayoko Konno', gender: 'F', alive: true, birth: '1926-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Zenjiroh Irokawa', gender: 'M', alive: false, birth: '1922-1-1', death: '1999-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Tomiko Konno', gender: 'F', alive: true, birth: '1928-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Rieki Konno', gender: 'M', alive: true, birth: '1934-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yukiko Ohgi', gender: 'F', alive: true, birth: '1936-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yoshinori Konno', gender: 'M', alive: true, birth: '1960-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Takako Satoh', gender: 'F', alive: true, birth: '1960-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Sinya Kanno', gender: 'M', alive: true, birth: '1994-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Eri Konno', gender: 'F', alive: true, birth: '1989-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Toshiko Konno', gender: 'F', alive: true, birth: '1958-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Tamotsu Kojima', gender: 'M', alive: true, birth: '1962-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Yuhto Kojima', gender: 'M', alive: true, birth: '1989-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Jiroh Konno', gender: 'M', alive: true, birth: '1937-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Naoshi Konno', gender: 'M', alive: true, birth: '1940-1-1',
    description: 'Conhecido somente o ano de nascimento. Dia e mês chutado.')
  Person.create(name: 'Hermenegildo Gonçalo da Silva', gender: 'M', alive: true, birth: '1966-1-8')
  Person.create(name: 'Lilian Hiromi Job', gender: 'F', alive: true, birth: '1976-11-14', kanji: '城 裕美')
  Person.create(name: 'Luna', gender: 'P', alive: true, birth: '2012-10-21')
  Person.create(name: 'Alice Tieco Todaki', gender: 'F', alive: true, birth: '1962-1-10')
  Person.create(name: 'Aroldo Yukio Todaki', gender: 'M', alive: true, birth: '1964-8-24',
    description: 'Natural de Inúbia Paulista SP')
  Person.create(name: 'Anderson Masao Todaki', gender: 'M', alive: true, birth: '1992-8-16', kanji: '雅夫',
    description: 'Natural da cidade de Hamakita na província de Shizuoka')
  Person.create(name: 'Tomoyo Job', gender: 'M', alive: true, birth: '1932-7-6', description: 'Natural de Braúna- SP')
  Person.create(name: 'Elza Yoshico Job', gender: 'F', alive: false, birth: '1938-9-25', death: '2020-1-12',
    description: 'Natural de Presidente Prudente - SP')
  Person.create(name: 'Kiyoshi Job', gender: 'M', alive: false, birth: '1965-1-10', death: '1965-1-21',
    description: 'Jazigo YP-I-15 Cemitério Vale da Paz')
  Person.create(name: 'Shizuma Job', gender: 'M', alive: false, birth: '1889-12-26',
    kanji: '城 静馬', description: 'Na migração consta como sobrenome Shiro. Partida de Kumamoto em 22/09/1928 e ' \
    'chegada em Santos em 12/11/1928 no navio Hawaii Maru')
  Person.create(name: 'Rumo Job', gender: 'F', alive: false, birth: '1891-10-26',
    kanji: '城 ルモ', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Minoru Miura', gender: 'M', alive: false)
  Person.create(name: 'Yuriko Miura', gender: 'F', alive: false)
  Person.create(name: 'Hiroyuki Todaki', gender: 'M', alive: true)
  Person.create(name: 'Sadako Todaki', gender: 'F', alive: true)
  Person.create(name: 'Alessandra Yukari Todaki', gender: 'F', alive: true, birth: '1994-11-12',
    description: 'Natural da cidade de Hamakita na província de Shizuoka')
  Person.create(name: 'Chiyo Shinozuka', gender: 'F', alive: true, birth: '1925-4-4', death: '1987-1-11',
    kanji: '篠塚 ちよ', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii ' \
    'Maru. Conhecida como Chiyoko. Cemitério Vale da Paz - Diadema')
  Person.create(name: 'Yasunaga Yokoyama', gender: 'M', alive: false, birth: '1926-7-2',
    kanji: '橫山康長', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Tama Shinozuka', gender: 'F', alive: false, birth: '1914-1-24', death: '1970-5-25',
    kanji: '篠塚 タマ', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii ' \
    'Maru. Nasc 24/01/1914? Cemitério Vale da Paz - Diadema')
  Person.create(name: 'Masakatsu Shinozuka', gender: 'M', alive: false, birth: '1909-3-31', death: '2001-9-2',
    kanji: '石元 正勝', description: 'Família Ishimoto. Cemitério Vale da Paz - Diadema')
  Person.create(name: 'Kiyoko Nagatomo', gender: 'F', alive: false,
    kanji: '城 嬌子', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Sadami Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Fumie Jyo', gender: 'F', alive: true)
  Person.create(name: 'Yoshinobu Jyo', gender: 'M', alive: false)
  Person.create(name: 'Ayako Jyo', gender: 'F', alive: true)
  Person.create(name: 'Marie Jyo', gender: 'F', alive: true)
  Person.create(name: 'Americo Makoto Jyo', gender: 'M', alive: true)
  Person.create(name: 'Masako Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Masahiro Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Mario Jyo', gender: 'M', alive: false)
  Person.create(name: 'Mery Jyo', gender: 'F', alive: true)
  Person.create(name: 'Yumio Jyo', gender: 'M', alive: false, birth: '1919-1-3',
    kanji: '城 弓桑', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Mitsue Jyo', gender: 'F', alive: true)
  Person.create(name: 'Jorge Matsumura', gender: 'M', alive: false)
  Person.create(name: 'Aparecida Mitiko Matsumura', gender: 'F', alive: true, birth: '1948-1-1',
    description: 'Data de nascimento chutada')
  Person.create(name: 'Daniel Matsumura', gender: 'M', alive: true, birth: '1980-4-9')
  Person.create(name: 'Carolina de Fatima Matsumura', gender: 'F', alive: true, birth: '1981-9-16')
  Person.create(name: 'Edgard Grossi', gender: 'M', alive: true, birth: '1982-8-7', description: 'Natural de São Paulo')
  Person.create(name: 'Cinthia Jyo Grossi', gender: 'F', alive: true, birth: '1984-1-17',
    description: 'Cinthia Jyo Matsumura')
  Person.create(name: 'Naomi Grossi Matsumura', gender: 'F', alive: true, birth: '2015-9-24',
    description: 'Natural de Bragança Paulista')
  Person.create(name: 'Aline Yumi Cerutte Matsumura', gender: 'F', alive: true, birth: '2001-3-10')
  Person.create(name: 'Hiro Saito', gender: 'F', alive: true, birth: '1912-11-26', death: '1988-12-31',
    kanji: '城 尋', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru. Conhecida como Tihiro.')
  Person.create(name: 'Takashi Saito', gender: 'M', alive: false)
  Person.create(name: 'Seiki Saito', gender: 'M', alive: false)
  Person.create(name: 'Keiko Saito', gender: 'M', alive: false)
  Person.create(name: 'Kouki Saito', gender: 'M', alive: false)
  Person.create(name: 'Kou Saito', gender: 'M', alive: true)
  Person.create(name: 'Tamaki Saito', gender: 'M', alive: true)
  Person.create(name: 'Sadako Saito', gender: 'F', alive: true)
  Person.create(name: 'Nobuo Jyo', gender: 'M', alive: false, birth: '1915-3-16', death: '1982-1-13',
    kanji: '城 信夫', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Mitsue Jyo', gender: 'F', alive: false, birth: '1922-1-1', death: '1997-10-21')
  Person.create(name: 'Antonio Coocei Jyo', gender: 'M', alive: true, birth: '1946-10-13')
  Person.create(name: 'Tereza Hatsuko Jyo', gender: 'F', alive: true, birth: '1944-2-9')
  Person.create(name: 'Leonardo Mitsuru Jyo', gender: 'M', alive: true, birth: '1982-12-2')
  Person.create(name: 'Lucio Masashigue Jyo', gender: 'M', alive: true, birth: '1986-7-22')
  Person.create(name: 'Nobuko Hayashihara', gender: 'F', alive: true, birth: '1948-3-17')
  Person.create(name: 'Ryu Hayashihara', gender: 'M', alive: false)
  Person.create(name: 'Denis Akira Hayashihara', gender: 'M', alive: true, birth: '1974-11-27')
  Person.create(name: 'Fernanda', gender: 'F', alive: true)
  Person.create(name: 'Eduardo Kazuya Hayashihara', gender: 'M', alive: true, birth: '1998-11-5')
  Person.create(name: 'Ângela Hayashihara', gender: 'F', alive: true, birth: '1980-5-23', description: 'Ângela Redkna')
  Person.create(name: 'Daniel Kazuo Hayashihara', gender: 'M', alive: true, birth: '2003-2-27')
  Person.create(name: 'Isabela Sakura Hayashihara', gender: 'F', alive: true, birth: '2006-8-31')
  Person.create(name: 'Nicolas Daiki Hayashihara', gender: 'M', alive: true, birth: '2010-1-4')
  Person.create(name: 'Dalton Hideo Hayashihara', gender: 'M', alive: true, birth: '1978-7-10')
  Person.create(name: 'Daniel Hiroshi Hayashihara', gender: 'M', alive: true, birth: '1979-12-4')
  Person.create(name: 'Adilson Nunes Pereira', gender: 'M', alive: true, description: 'Natural de São Paulo')
  Person.create(name: 'Adriana Hitomi Morinaga', gender: 'F', alive: true, birth: '1986-8-9')
  Person.create(name: 'Adriana Mitsue Matsuda', gender: 'F', alive: true, birth: '1982-11-6')
  Person.create(name: 'Adriana Miyuki Suzuki', gender: 'F', alive: true)
  Person.create(name: 'Aiko', gender: 'F', alive: true)
  Person.create(name: 'Akemi', gender: 'F', alive: true)
  Person.create(name: 'Akemi', gender: 'F', alive: true)
  Person.create(name: 'Akiko Suzuki', gender: 'F', alive: true)
  Person.create(name: 'Alexandra Miyuki Teramoto', gender: 'F', alive: true, birth: '1981-11-17',
    description: 'Natural de São Paulo')
  Person.create(name: 'Alexandre Fukushima', gender: 'M', alive: true)
  Person.create(name: 'Alexandro Simabuco', gender: 'M', alive: true, birth: '1980-11-18', description: 'Natural do Paraná')
  Person.create(name: 'Alice de Freitas Jyo Malfatti', gender: 'F', alive: true, birth: '2017-1-2',
    description: 'Natural de São Paulo')
  Person.create(name: 'Alice Masami Jyo Rodrigues', gender: 'F', alive: true, birth: '1963-10-30',
    description: 'Natural de São Paulo')
  Person.create(name: 'Alice Takako Kaneko Abe', gender: 'F', alive: true, birth: '1954-12-5',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Alice Tokiko Mikado', gender: 'F', alive: true, birth: '1959-7-22')
  Person.create(name: 'Aline Kaneko', gender: 'F', alive: true, birth: '1990-4-13', description: 'Natural de São Paulo')
  Person.create(name: 'Amélia Makiko Jyo', gender: 'F', alive: true, birth: '1954-7-10',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Ana de Oliveira Neto Mikado', gender: 'F', alive: true)
  Person.create(name: 'Antonio Hajime Takazono', gender: 'M', alive: true, birth: '1942-3-8')
  Person.create(name: 'Antonio Masahiro Jyo', gender: 'M', alive: true, birth: '1957-5-5',
    description: 'Natural de São Paulo')
  Person.create(name: 'Augusto Tacao Jyo', gender: 'M', alive: true, birth: '1961-8-15',
    description: 'Natural de São Paulo')
  Person.create(name: 'Aya', gender: 'F', alive: true)
  Person.create(name: 'Caio Tetsuo Jyo', gender: 'M', alive: true, birth: '2005-7-30')
  Person.create(name: 'Camila Hiromi Abe', gender: 'F', alive: true, birth: '1983-12-20',
    description: 'Natural de São Paulo')
  Person.create(name: 'Carlos Eugênio Malfatti', gender: 'M', alive: false)
  Person.create(name: 'Carlos Eugênio Malfatti Júnior', gender: 'M', alive: true, birth: '1985-2-6')
  Person.create(name: 'Carlos Joji Ueno', gender: 'M', alive: true, birth: '1953-2-1')
  Person.create(name: 'Carol Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Carolina Marie Tagami', gender: 'F', alive: true, birth: '2002-4-12',
    description: 'Natural de São Paulo')
  Person.create(name: 'Cecília Mieko Kaneko', gender: 'F', alive: true, birth: '1961-3-16',
    description: 'Natural de São Paulo')
  Person.create(name: 'Cintia Biáforo Jyo', gender: 'F', alive: true)
  Person.create(name: 'Cristiane Liuko Jyo', gender: 'F', alive: true, birth: '1965-9-10')
  Person.create(name: 'Daniel Akira Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Daniel Hideki Ueno', gender: 'M', alive: true, birth: '1981-2-23',
    description: 'Natural de São Paulo')
  Person.create(name: 'Daniella Mello', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Eishima', gender: 'M', alive: false, description: 'Natural do Japão')
  Person.create(name: 'Sem cadastro Mikado', gender: 'F', alive: true)
  Person.create(name: 'Dirce Kazuko Kaneko', gender: 'F', alive: true, birth: '1962-9-26',
    description: 'Natural de São Paulo')
  Person.create(name: 'Drayton', gender: 'M', alive: true)
  Person.create(name: 'Dylan Nishina', gender: 'M', alive: true, birth: '2002-1-28', description: 'Natural de São Paulo')
  Person.create(name: 'Eby Hisayo Kaneko', gender: 'F', alive: true, birth: '1956-1-27')
  Person.create(name: 'Sem cadastro Matsuda', gender: 'M', alive: false)
  Person.create(name: 'Eduardo Hideki Matsuda', gender: 'M', alive: true, birth: '1985-9-16')
  Person.create(name: 'Eduardo Seiji Nishida', gender: 'M', alive: true, birth: '2013-4-25',
    description: 'Natural de São Paulo')
  Person.create(name: 'Elido Augusto Vital', gender: 'M', alive: true)
  Person.create(name: 'Elisa Suemi Kaneko', gender: 'F', alive: true, birth: '1966-3-12',
    description: 'Natural de São Paulo')
  Person.create(name: 'Eliza Satiyo Motoike', gender: 'F', alive: true)
  Person.create(name: 'Eliza Tiemi Takeda', gender: 'F', alive: false)
  Person.create(name: 'Elizabeth Miyagusuku', gender: 'F', alive: true, birth: '1905-5-19')
  Person.create(name: 'Emiko Matsuda', gender: 'F', alive: true, description: 'Natural do Japão')
  Person.create(name: 'Eric Eiji Jyo', gender: 'M', alive: true, birth: '2004-8-20')
  Person.create(name: 'Érika Kaneko', gender: 'F', alive: true, birth: '1988-2-12', description: 'Natural de São Paulo')
  Person.create(name: 'Fabiana', gender: 'F', alive: true)
  Person.create(name: 'Fabio', gender: 'M', alive: true)
  Person.create(name: 'Fábio Akira Kaneko', gender: 'M', alive: true, birth: '2000-2-28',
    description: 'Natural de São Paulo')
  Person.create(name: 'Fabio Hideki Mikado', gender: 'M', alive: true)
  Person.create(name: 'Fernando Takashi Kaneko', gender: 'M', alive: true, birth: '2003-3-28',
    description: 'Natural de São Paulo')
  Person.create(name: 'Fumiko Tanaka', gender: 'F', alive: true)
  Person.create(name: 'Fusako Takeshita', gender: 'F', alive: true)
  Person.create(name: 'Gabriela Yumi Rodrigues', gender: 'F', alive: true, birth: '2000-3-21',
    description: 'Natural de São Paulo')
  Person.create(name: 'Gerson Koichi Miike', gender: 'M', alive: true, birth: '1970-12-20')
  Person.create(name: 'Giovanna Ayumi da Silva', gender: 'F', alive: true, birth: '2014-3-11')
  Person.create(name: 'Guilherme Erick Seiji Takazono', gender: 'M', alive: true, birth: '2006-8-19')
  Person.create(name: 'Gustavo Hideaki Simabuco', gender: 'M', alive: true, birth: '2006-10-30',
    description: 'Natural de Curitiba - PR')
  Person.create(name: 'Gustavo Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Helena Midori Kaneko', gender: 'F', alive: true, birth: '1949-1-25')
  Person.create(name: 'Heloisa Fukushima', gender: 'F', alive: true)
  Person.create(name: 'Hideki Mikado', gender: 'M', alive: true, birth: '1961-11-16')
  Person.create(name: 'Jhonny Makoto Abe', gender: 'M', alive: true, birth: '2011-5-27',
    description: 'Natural de Pilar do Sul - SP')
  Person.create(name: 'João Manabu Kuamoto', gender: 'M', alive: true)
  Person.create(name: 'Jorge Tagami', gender: 'M', alive: true)
  Person.create(name: 'Jorge Yuzuru Teramoto', gender: 'M', alive: true, birth: '1948-8-1')
  Person.create(name: 'José Masayuki Kaneko', gender: 'M', alive: true, birth: '1953-1-1',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'José Mikado', gender: 'M', alive: false, description: 'Natural do Japão')
  Person.create(name: 'Júlia Akemi', gender: 'F', alive: true)
  Person.create(name: 'Julia Mei Biaforo Jyo', gender: 'F', alive: true, birth: '2007-5-12',
    description: 'Natural de São Paulo')
  Person.create(name: 'Juliana Akemi Ueno', gender: 'F', alive: true, birth: '1984-3-14',
    description: 'Natural de São Paulo')
  Person.create(name: 'Juliana de Freitas Malfatti', gender: 'F', alive: true)
  Person.create(name: 'Julio Nishida', gender: 'M', alive: true, birth: '2004-5-7', description: 'Natural do Japão')
  Person.create(name: 'Jun', gender: 'M', alive: true)
  Person.create(name: 'Karen Jyo', gender: 'F', alive: true, birth: '1970-8-25')
  Person.create(name: 'Karina Tieko Mikado', gender: 'F', alive: true)
  Person.create(name: 'Katsuki Suzuki', gender: 'M', alive: true)
  Person.create(name: 'Katsushi Jyo', gender: 'M', alive: true, birth: '1955-7-26')
  Person.create(name: 'Kazue Mikado', gender: 'F', alive: false, description: 'Natural do Japão')
  Person.create(name: 'Kazumi', gender: 'F', alive: true)
  Person.create(name: 'Keiji', gender: 'M', alive: true)
  Person.create(name: 'Kenzo Yamaniha', gender: 'M', alive: true)
  Person.create(name: 'Kimiko Kuamoto', gender: 'F', alive: true)
  Person.create(name: 'Koiti Matsuda', gender: 'M', alive: true, birth: '1950-4-3')
  Person.create(name: 'Kouki Jyo', gender: 'M', alive: true)
  Person.create(name: 'Kyoji Matsuda', gender: 'M', alive: true)
  Person.create(name: 'Lauro Eishima', gender: 'M', alive: true, birth: '1944-8-1')
  Person.create(name: 'Leonardo', gender: 'M', alive: true)
  Person.create(name: 'Letícia Jyo Pereira', gender: 'F', alive: true, birth: '1995-8-11')
  Person.create(name: 'Lilian Mayumi Nishida', gender: 'F', alive: true, birth: '1983-6-7',
    description: 'Natural de São Paulo')
  Person.create(name: 'Lincoln Koiti Jyo', gender: 'M', alive: true)
  Person.create(name: 'Linton Hiroki Abe', gender: 'M', alive: true, birth: '1951-7-29',
    description: 'Natural de Bastos - SP')
  Person.create(name: 'Lua Fukushima', gender: 'F', alive: true)
  Person.create(name: 'Luci', gender: 'F', alive: true)
  Person.create(name: 'Lucimeire Suzuki', gender: 'F', alive: true, birth: '1972-12-24')
  Person.create(name: 'Luis Jyo', gender: 'M', alive: true, birth: '1944-9-19')
  Person.create(name: 'Luiz', gender: 'M', alive: true)
  Person.create(name: 'Luiza Naoko Teramoto', gender: 'F', alive: true, birth: '1951-8-26',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Mana Fukushima', gender: 'F', alive: true)
  Person.create(name: 'Marcel Yuji Ueno', gender: 'M', alive: true, birth: '1982-10-5', description: 'Natural de São Paulo')
  Person.create(name: 'Marcella Monaco Jyo', gender: 'F', alive: true, birth: '1990-1-19',
    description: 'Natural de São Paulo')
  Person.create(name: 'Marcelo Takeshi Kaneko', gender: 'M', alive: true, birth: '1992-9-27',
    description: 'Natural de São Paulo')
  Person.create(name: 'Marcia M. Okumura Jyo', gender: 'F', alive: true, birth: '1962-10-1')
  Person.create(name: 'Márcia Monaco', gender: 'F', alive: true, birth: '1960-4-2', description: 'Natural de São Paulo')
  Person.create(name: 'Márcio Eiiti Kaneko', gender: 'M', alive: true, birth: '1977-4-30',
    description: 'Natural de São Paulo')
  Person.create(name: 'Marcio Hideki Nishida', gender: 'M', alive: true, birth: '1978-3-16')
  Person.create(name: 'Marcos Kenji Kaneko', gender: 'M', alive: true, birth: '1983-5-10',
    description: 'Natural de São Paulo')
  Person.create(name: 'Mariana Tiemi Matsuda', gender: 'F', alive: true, birth: '1990-7-10',
    description: 'Natural de São Paulo')
  Person.create(name: 'Mariane Yumi Abe', gender: 'F', alive: true, birth: '2013-1-8',
    description: 'Natural de Pilar do Sul - SP')
  Person.create(name: 'Marianna Emy Takazono', gender: 'F', alive: true)
  Person.create(name: 'Marina Ayumi Jyo', gender: 'F', alive: true)
  Person.create(name: 'Marli Fukushima', gender: 'F', alive: true)
  Person.create(name: 'Masanori Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Masayuki', gender: 'M', alive: true)
  Person.create(name: 'Matao Matsumura', gender: 'M', alive: false)
  Person.create(name: 'Melissa Miike', gender: 'F', alive: true, birth: '2004-3-5')
  Person.create(name: 'Mieko Jyo Eishima', gender: 'F', alive: true, birth: '1955-6-29')
  Person.create(name: 'Mikio Mikado', gender: 'M', alive: true, birth: '1954-9-27')
  Person.create(name: 'Milton Hiroshi Matsuno', gender: 'M', alive: true, birth: '1955-4-1')
  Person.create(name: 'Mioji Matsumura', gender: 'F', alive: false)
  Person.create(name: 'Mirian Megumi Suzuki', gender: 'F', alive: true)
  Person.create(name: 'Mitiko Jyo', gender: 'F', alive: true, birth: '1944-7-1')
  Person.create(name: 'Mitsuaki', gender: 'M', alive: true)
  Person.create(name: 'Mitsuko Matsuda', gender: 'F', alive: true)
  Person.create(name: 'Mizue', gender: 'F', alive: true)
  Person.create(name: 'Mizue Jyo', gender: 'F', alive: true, birth: '1953-2-20')
  Person.create(name: 'Mombe Wakamori', gender: 'M', alive: false)
  Person.create(name: 'Natália Yurie Jyo', gender: 'F', alive: true, birth: '1990-2-24',
    description: 'Natural de São Paulo')
  Person.create(name: 'Nelson Masamitsu Mikado', gender: 'M', alive: true, birth: '1952-8-9')
  Person.create(name: 'Nelson Masanori Jyo', gender: 'M', alive: true, birth: '1960-4-26')
  Person.create(name: 'Neusa Hetsuko Kaneko Ueno', gender: 'F', alive: true, birth: '1958-11-19',
    description: 'Natural de São Paulo')
  Person.create(name: 'Newton Hideki Suzuki', gender: 'M', alive: false)
  Person.create(name: 'Nobuko Kaneko', gender: 'F', alive: true, birth: '1948-7-3')
  Person.create(name: 'Noriaki Jyo', gender: 'M', alive: true)
  Person.create(name: 'Norisato Jyo', gender: 'M', alive: true, birth: '1923-9-18', death: '2001-1-1',
    kanji: '城 徳達', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru. Conhecido somente o ano do falecimento')
  Person.create(name: 'Oscar Kiyomi Kaneko', gender: 'M', alive: true, birth: '1956-8-18',
    description: 'Natural de São Paulo')
  Person.create(name: 'Paulo Akio Kaneko', gender: 'M', alive: true, birth: '1950-2-23',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Paulo Eduardo Maia Lourenço', gender: 'M', alive: true)
  Person.create(name: 'Paulo Mikado', gender: 'M', alive: true, birth: '1957-1-1')
  Person.create(name: 'Paulo Takaaki Jyo', gender: 'M', alive: true)
  Person.create(name: 'Priscila Mayumi Seki Mikado', gender: 'F', alive: true)
  Person.create(name: 'Rachel Moraes', gender: 'F', alive: true)
  Person.create(name: 'Rafael Seiki Teramoto', gender: 'M', alive: true, birth: '1983-1-5',
    description: 'Natural de São Paulo')
  Person.create(name: 'Rafael Yukio Jyo', gender: 'M', alive: true)
  Person.create(name: 'Rafaela Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Renato Satio Kaneko', gender: 'M', alive: true, birth: '1988-4-6',
    description: 'Natural de São Paulo')
  Person.create(name: 'Renato Seiji Eishima', gender: 'M', alive: true, birth: '1983-12-31')
  Person.create(name: 'Ricardo', gender: 'M', alive: true)
  Person.create(name: 'Ricardo Makoto Abe', gender: 'M', alive: true, birth: '1981-5-1',
    description: 'Natural de São Paulo')
  Person.create(name: 'Ricardo Seki Mikado', gender: 'M', alive: true)
  Person.create(name: 'Rodrigo', gender: 'M', alive: true)
  Person.create(name: 'Rodrigo Hajime Takazono', gender: 'M', alive: true)
  Person.create(name: 'Rogério Radyme Takazono', gender: 'M', alive: true, birth: '1972-9-17')
  Person.create(name: 'Ronaldo Fukushima', gender: 'M', alive: true)
  Person.create(name: 'Rosa Kazuko Mikado', gender: 'F', alive: true, birth: '1950-9-18')
  Person.create(name: 'Rosa Kimie Kaneko', gender: 'F', alive: true, birth: '1955-11-8',
    description: 'Natural de Dracena - SP')
  Person.create(name: 'Rosangela Eiko Takazono', gender: 'F', alive: true, birth: '1973-11-13')
  Person.create(name: 'Rose', gender: 'F', alive: true)
  Person.create(name: 'Roseli Mie Jyo', gender: 'F', alive: true)
  Person.create(name: 'Rubens de Oliveira Rodrigues', gender: 'M', alive: true, birth: '1963-6-26',
    description: 'Natural de São Paulo')
  Person.create(name: 'Rubens Haruo Eishima', gender: 'M', alive: true, birth: '1982-8-25')
  Person.create(name: 'Sandra dos Santos Alencar', gender: 'F', alive: true, birth: '1980-1-12')
  Person.create(name: 'Sandra Sayuri Suzuki', gender: 'F', alive: true, description: 'Niver 23/02')
  Person.create(name: 'Sachiko Jyo Mikado', gender: 'F', alive: true, birth: '1926-2-20',
    kanji: '城 幸子', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Satoshi Fukushima', gender: 'M', alive: true)
  Person.create(name: 'Selma Kaneko', gender: 'F', alive: true, birth: '1977-11-29',
    description: 'Natural de Pereira Barreto - SP')
  Person.create(name: 'Sergio Bernardy', gender: 'M', alive: true)
  Person.create(name: 'Shinji', gender: 'M', alive: true)
  Person.create(name: 'Shizuori Jyo', gender: 'M', alive: true, birth: '1909-11-18',
    kanji: '城 静織', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Sophia Sayuri Abe', gender: 'F', alive: true, birth: '2003-5-8',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Suzana Yassue Eishima', gender: 'F', alive: true, birth: '1985-6-3',
    description: 'Natural de São Paulo')
  Person.create(name: 'Tadashi Kaneko', gender: 'M', alive: true, birth: '1948-1-26',
    description: 'Natural de Marialva - PR')
  Person.create(name: 'Takashi', gender: 'M', alive: true)
  Person.create(name: 'Takefumi Kaneko', gender: 'M', alive: false, birth: '1923-6-4', death: '2005-11-26',
    description: 'Natural do Japão')
  Person.create(name: 'Takeshi', gender: 'M', alive: true)
  Person.create(name: 'Takeshi Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Takio Matsuda', gender: 'M', alive: true)
  Person.create(name: 'Tamae Wakamori', gender: 'F', alive: false)
  Person.create(name: 'Teruko Jyo Matsuda', gender: 'F', alive: true)
  Person.create(name: 'Theo Seiji Jyo', gender: 'M', alive: true, birth: '2008-5-30', description: 'Natural de São Paulo')
  Person.create(name: 'Thiago Masao Mikado', gender: 'M', alive: true, birth: '1985-1-29')
  Person.create(name: 'Thiago Tetsuya Rodrigues', gender: 'M', alive: true, birth: '1997-8-27',
    description: 'Natural de São Paulo')
  Person.create(name: 'Tiemi', gender: 'F', alive: true)
  Person.create(name: 'Toshiko Eishima', gender: 'F', alive: false, description: 'Natural do Japão')
  Person.create(name: 'Toshiko Jyo', gender: 'F', alive: true, birth: '1920-10-23', death: '2017-1-1',
    description: 'Natural do Japão - Conhecido somente o ano do falecimento')
  Person.create(name: 'Toyoko Takeshita', gender: 'F', alive: true)
  Person.create(name: 'Tsuneto Takeshita', gender: 'M', alive: false)
  Person.create(name: 'Valentino Nishina', gender: 'M', alive: true, birth: '1962-9-1')
  Person.create(name: 'Vanessa Mieko Tagami', gender: 'F', alive: true, birth: '1997-1-24', description: 'Natural do Japão')
  Person.create(name: 'Victor Fukushima', gender: 'M', alive: true)
  Person.create(name: 'Victor Kaneko Matsuno', gender: 'M', alive: true, birth: '1990-4-3',
    description: 'Natural de São Paulo')
  Person.create(name: 'Yasmim Sayuri', gender: 'F', alive: true)
  Person.create(name: 'Yasmin Tiemi Mikado Lourenço', gender: 'F', alive: true)
  Person.create(name: 'Yoshiaki Mikado', gender: 'M', alive: false, birth: '1923-3-27', death: '1986-7-23')
  Person.create(name: 'Yoshie Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Yoshie Takazono', gender: 'F', alive: true, birth: '1948-10-23')
  Person.create(name: 'Yoshiko Jyo', gender: 'F', alive: false, birth: '1929-10-5', death: '2013-1-31',
    description: 'Natural do Japão')
  Person.create(name: 'Yudi Gunter Jyo Bernardy', gender: 'M', alive: true)
  Person.create(name: 'Yuiko Kaneko', gender: 'F', alive: true, birth: '1921-3-20', death: '2002-5-5',
    kanji: '城 ユイ', description: 'Partida de Kumamoto em 22/09/1928 e chegada em Santos em 12/11/1928 no navio ' \
    'Hawaii Maru')
  Person.create(name: 'Yukio', gender: 'M', alive: true)
  Person.create(name: 'Yutaka Yamaniha', gender: 'M', alive: true)
  Person.create(name: 'Yuzo', gender: 'M', alive: true)
  Person.create(name: 'Masako Nagatomo', gender: 'F', alive: true, birth: '1942-2-20')
  Person.create(name: 'Yassuo', gender: 'M', alive: true)
  Person.create(name: 'Oswaldo Makoto Kuamoto', gender: 'M', alive: true)
  Person.create(name: 'Rogerio Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'João Fernandes', gender: 'M', alive: true)
  Person.create(name: 'Madalena Fernandes Mello', gender: 'F', alive: true)
  Person.create(name: 'Katsujiro Omi', gender: 'M', alive: false, birth: '1917-1-21', death: '2018-11-13',
    kanji: '尾身 勝次郎', description: 'Tochigi. Entrada em Santos no Brasil em 24 de agosto de 1932 no navio ' \
    'Buenos Aires Maru')
  Person.create(name: 'Ei Omi', gender: 'F', alive: false, birth: '1921-7-21', death: '2005-2-11',
    kanji: '二宮榮', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru. ' \
    'Faleceu em São Paulo/SP')
  Person.create(name: 'Fernando de Brito', gender: 'M', alive: false)
  Person.create(name: 'Julieta de Luna Brito', gender: 'F', alive: false)
  Person.create(name: 'Ivino Carneiro da Silva', gender: 'M', alive: false)
  Person.create(name: 'Quitéria Basílio da Silva', gender: 'F', alive: false)
  Person.create(name: 'Kusuichi Nakao', gender: 'M', alive: false, birth: '1907-1-1',
    kanji: '中尾 九洲一', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. Conhecido ' \
    'somente o ano do nascimento')
  Person.create(name: 'Haguine Nakao', gender: 'F', alive: false)
  Person.create(name: 'Sem cadastro Matsubara', gender: 'M', alive: false)
  Person.create(name: 'Kazue Matsubara', gender: 'F', alive: false)
  Person.create(name: 'Tomiko Matsubara', gender: 'F', alive: true)
  Person.create(name: 'Kelly Simões de Lima', gender: 'F', alive: true, birth: '1979-10-18')
  Person.create(name: 'Igor Osawa', gender: 'M', alive: true, description: 'Niver 29 de dezembro')
  Person.create(name: 'Ravel Michellom Kirschke Fagundes', gender: 'M', alive: true, birth: '1988-5-22')
  Person.create(name: 'Lais Fregonezi', gender: 'F', alive: true, birth: '1986-7-25')
  Person.create(name: 'Teresa', gender: 'F', alive: true, description: 'Niver 12 de maio')
  Person.create(name: 'Leonardo Kenji Sakamoto', gender: 'M', alive: true, description: 'Niver 26 de agosto')
  Person.create(name: 'Leonardo Masao Osawa', gender: 'M', alive: false, birth: '2010-12-22', death: '2018-11-19')
  Person.create(name: 'Luciana Mei Osawa', gender: 'F', alive: true, birth: '2016-4-26')
  Person.create(name: 'Pedro Fabiano de Morais Sarmento', gender: 'M', alive: true, birth: '1979-8-24')
  Person.create(name: 'Felipe Sakamoto Sarmento', gender: 'M', alive: true, birth: '2009-5-13')
  Person.create(name: 'Lila Sakamoto Sarmento', gender: 'F', alive: true, birth: '2018-11-1')
  Person.create(name: 'Roberto Hideki Ueno', gender: 'M', alive: true, birth: '2013-12-24')
  Person.create(name: 'Carol Lacerda', gender: 'F', alive: true)
  Person.create(name: 'Noah Kai Lacerda Sakamoto', gender: 'M', alive: true, birth: '2014-9-15')
  Person.create(name: 'Gabriel Fregonezi Sakamoto', gender: 'M', alive: true, birth: '2016-2-16')
  Person.create(name: 'Júlia Fregonezi Sakamoto', gender: 'F', alive: true, birth: '2019-1-5')
  Person.create(name: 'Sem cadastro Helena Tanaka', gender: 'M', alive: true)
  Person.create(name: 'Marisa', gender: 'F', alive: true)
  Person.create(name: 'Gabriela', gender: 'F', alive: true)
  Person.create(name: 'Masaru Shinozuka', gender: 'M', alive: false)
  Person.create(name: 'Maria Marie Yokoyama', gender: 'F', alive: true)
  Person.create(name: 'Emilia Emiko Heira', gender: 'F', alive: true, birth: '1943-9-30',
    description: 'Presidente Prudente/SP')
  Person.create(name: 'Luiza Misayo Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Rosa Kikue Hirata', gender: 'F', alive: true)
  Person.create(name: 'Masae Eishima', gender: 'F', alive: false)
  Person.create(name: 'Milton Eishima', gender: 'M', alive: false)
  Person.create(name: 'Carlos Akio Hirata', gender: 'M', alive: true)
  Person.create(name: 'Terumitsu Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Masanori Heira', gender: 'M', alive: true, birth: '1941-3-23',
    kanji: '平良政法', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Yutaka Yokoyama', gender: 'M', alive: true)
  Person.create(name: 'Tiyoko Shinozuka', gender: 'F', alive: true)
  Person.create(name: 'Yoshiaki Shinozuka', gender: 'M', alive: true)
  Person.create(name: 'Yassuo Shinozuka', gender: 'M', alive: true)
  Person.create(name: 'Masanobu Shinozuka', gender: 'M', alive: true)
  Person.create(name: 'Harumi Shinozuka', gender: 'F', alive: true)
  Person.create(name: 'Miyuki Yokoyama', gender: 'F', alive: true)
  Person.create(name: 'Francisco Koretika Heira', gender: 'M', alive: true)
  Person.create(name: 'Marta Yoshiko Heira', gender: 'F', alive: true)
  Person.create(name: 'Roberto Kiyotaka Nagatomo', gender: 'M', alive: true)
  Person.create(name: 'Nicia Toshiko Nagatomo', gender: 'F', alive: true)
  Person.create(name: 'Claudio Mitio Hirata', gender: 'M', alive: true)
  Person.create(name: 'Regina Kiyomi Hirata Kamogawa', gender: 'F', alive: true)
  Person.create(name: 'Erica Harumi Eishima Tanabe', gender: 'F', alive: true)
  Person.create(name: 'Emilia Emiko Eishima', gender: 'F', alive: true)
  Person.create(name: 'Mari Eishima Chikasawa', gender: 'F', alive: true)
  Person.create(name: 'Regina Yoko Eishima', gender: 'F', alive: true)
  Person.create(name: 'Rimpei Shinozuka', gender: 'M', alive: false, birth: '1898-1-4',
    kanji: '篠塚 林兵衛', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii Maru')
  Person.create(name: 'Toku Shinozuka', gender: 'F', alive: false, birth: '1897-2-9',
    kanji: '篠塚 とく', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii Maru')
  Person.create(name: 'Sukehei Shinozuka', gender: 'M', alive: true,
    kanji: '篠塚 助兵衛', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii Maru')
  Person.create(name: 'Teinosuke Shinozuka', gender: 'M', alive: true,
    kanji: '篠塚 貞之介', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii Maru')
  Person.create(name: 'Seizo Shinozuka', gender: 'M', alive: true,
    kanji: '篠塚 淸三', description: 'Ibaraki. Entrada em Santos no Brasil em 16 de abril de 1930 no navio Hawaii Maru')
  Person.create(name: 'Miyoko Shinozuka', gender: 'F', alive: true)
  Person.create(name: 'Shinobu Shinozuka', gender: 'M', alive: true)
  Person.create(name: 'Keiya Shinozuka', gender: 'M', alive: true)
  Person.create(name: 'Kaoru Shinozuka', gender: 'F', alive: true)
  Person.create(name: 'Kiyoko Shinozuka', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Thomazelli', gender: 'M', alive: true)
  Person.create(name: 'Mariana Sakamoto', gender: 'F', alive: true, birth: '2013-5-12')
  Person.create(name: 'Kenzo Sakamoto Tomazelli', gender: 'M', alive: true, birth: '2015-12-31')
  Person.create(name: 'Toshiya Yamada', gender: 'M', alive: true)
  Person.create(name: 'Guto Tanabe', gender: 'M', alive: true)
  Person.create(name: 'Robson Chikasawa', gender: 'M', alive: true)
  Person.create(name: 'Melissa Ayumi Osawa', gender: 'F', alive: true, birth: '2020-6-11')
  Person.create(name: 'Melissa Fregonezi Sakamoto', gender: 'F', alive: true, birth: '2020-7-31')
  Person.create(name: 'Sayaka Yamada', gender: 'F', alive: true, birth: '2020-9-19', kanji: '楓__')
  Person.create(name: 'Joelcio Almeida', gender: 'M', alive: true, birth: '1971-11-13')
  Person.create(name: 'João Otake Almeida', gender: 'M', alive: true, birth: '2021-6-12',
    description: 'Nasceu as 14:11 com 3,115 kg e 48,5 cm')
  Person.create(name: 'Tihiro Miyahara', gender: 'F', alive: true, birth: '1998-10-2')
  Person.create(name: 'Aki Miyahara', gender: 'F', alive: true, birth: '2018-8-2')
  Person.create(name: 'Anderson Soucha', gender: 'M', alive: true)
  Person.create(name: 'Rodrigo Akira', gender: 'M', alive: true, birth: '2021-8-8')
  Person.create(name: 'Milton Kogushi', gender: 'M', alive: true)
  Person.create(name: 'Iris Souza Otake', gender: 'F', alive: true, birth: '2014-12-18')
  Person.create(name: 'Yasushi Omi', gender: 'M', alive: false)
  Person.create(name: 'Yuki Omi', gender: 'F', alive: false)
  Person.create(name: 'Tsuya Nakasawa', gender: 'M', alive: false)
  Person.create(name: 'Ino Nakasawa', gender: 'F', alive: false)
  Person.create(name: 'Sakutaro Nakaji', gender: 'M', alive: false)
  Person.create(name: 'Kiku Nakaji', gender: 'F', alive: false)
  Person.create(name: 'Tokogo Ueno', gender: 'M', alive: false)
  Person.create(name: 'Mitie Ueno', gender: 'F', alive: false)
  Person.create(name: 'Fumie Ishimoto', gender: 'F', alive: false)
  Person.create(name: 'Otsuru Yamamoto', gender: 'F', alive: false)
  Person.create(name: 'Sem cadastro Yamamoto', gender: 'M', alive: false)
  Person.create(name: 'Masahiro Isaka', gender: 'M', alive: false, birth: '1925-6-10',
    kanji: '井坂 正弘', description: 'Fukui. Entrada em Santos no Brasil em 01 de Setembro de 1927 no navio Manila Maru')
  Person.create(name: 'Foobum Saito', gender: 'M', alive: true)
  Person.create(name: 'Tatsuji Uemoto', gender: 'M', alive: false, birth: '1904-1-1',
    kanji: '上本 辰治', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Tamayo Uemoto', gender: 'F', alive: false, birth: '1905-1-1',
    kanji: '上本 多滿代', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Jishiro Uemoto', gender: 'M', alive: false, birth: '1877-1-1',
    kanji: '上本 治四郎', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Haruno Uemoto', gender: 'F', alive: false, birth: '1884-1-1',
    kanji: '上本 ハルノ', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Sumio Uemoto', gender: 'M', alive: false, birth: '1924-1-1',
    kanji: '上本 住雄', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
  'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Sumito Uemoto', gender: 'M', alive: false, birth: '1926-1-1',
    kanji: '上本 住人', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Eiichi Uemoto', gender: 'M', alive: false, birth: '1911-1-1',
    kanji: '上本 榮市', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
  'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Matsuyo Uemoto', gender: 'F', alive: false, birth: '1913-1-1',
    kanji: '上本 マツヨ', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Ryu Uemoto', gender: 'F', alive: false, birth: '1849-1-1',
    kanji: '上本 リウ', description: 'Hiroshima. Entrada em Santos/SP em 16 de janeiro de 1927 no navio Santos Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Saichi Ishimoto', gender: 'M', alive: false)
  Person.create(name: 'Ushi Ishimoto', gender: 'F', alive: false)
  Person.create(name: 'Naozane Heira', gender: 'M', alive: false)
  Person.create(name: 'Michi Heira', gender: 'F', alive: false, birth: '1918-2-24',
    kanji: '平良ミチ', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Sakuhide So', gender: 'M', alive: false)
  Person.create(name: 'Tsuru So', gender: 'F', alive: false)
  Person.create(name: 'Tae Takemiya', gender: 'F', alive: false, birth: '1924-8-27',
    kanji: '武宮タへ', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Korefumi Takemiya', gender: 'M', alive: true, birth: '1949-6-28',
    kanji: '武宮是文', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Hideo Takemiya', gender: 'M', alive: false, birth: '1917-7-10',
    kanji: '武宮英夫', description: 'Kagoshima. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Nobu Nishimura', gender: 'F', alive: false, birth: '1925-1-1',
    kanji: '宗ノブ', description: 'Fukuoka. Nobu So. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Koreaki Takemiya', gender: 'M', alive: false)
  Person.create(name: 'Tsuru Takemiya', gender: 'F', alive: false)
  Person.create(name: 'Yasuko Heira', gender: 'F', alive: true, birth: '1945-10-18',
    kanji: '平良康子', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Kyoko Okawa', gender: 'F', alive: true, birth: '1949-6-15',
    kanji: '平良京子', description: 'Fukuoka. Entrada em Santos/SP em 11 de março de 1959 no navio Boissevain')
  Person.create(name: 'Antonio Masarmi Omi', gender: 'M', alive: true, birth: '1950-11-19',
    description: 'São Miguel Arcanjo/SP')
  Person.create(name: 'Eisaku Ninomiya', gender: 'M', alive: false, birth: '1895-11-21', death: '1972-4-17',
    kanji: '二宮榮作', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru. ' \
    'Faleceu em São Paulo/SP')
  Person.create(name: 'Saki Inoue', gender: 'F', alive: false, birth: '1897-2-21', death: '1980-11-7',
    kanji: '二宮サキ', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru. ' \
    'Faleceu em São Paulo/SP')
  Person.create(name: 'Hideei Ninomiya', gender: 'M', alive: false, birth: '1924-1-1', death: '1985-5-12',
    kanji: '二宮秀榮', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru. ' \
    'Faleceu em Diadema/SP')
  Person.create(name: 'Michiko Ninomiya', gender: 'F', alive: false, birth: '1927-11-2',
    kanji: '二宮美智子', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru')
  Person.create(name: 'Katsumi Ninomiya', gender: 'M', alive: false, birth: '1936-4-28', death: '1992-8-23',
    description: 'Bauru/SP. Faleceu em Sorocaba/SP')
  Person.create(name: 'Yoshii Inoue', gender: 'F', alive: false, birth: '1906-7-29',
    kanji: '井上 ヨシイ', description: 'Niigata. Entrada em Santos/SP em 09 de outubro de 1930 no navio La Plata Maru')
  Person.create(name: 'Tozo Misu', gender: 'M', alive: false)
  Person.create(name: 'Aki Misu', gender: 'F', alive: false)
  Person.create(name: 'Tsuna Misu Komatsu', gender: 'F', alive: false, birth: '1926-1-1',
    description: 'Gifu. Dia e mes de nascimento desconhecido')
  Person.create(name: 'Isuke Kariatsumari', gender: 'M', alive: false)
  Person.create(name: 'Ichiki Kariatsumari', gender: 'F', alive: false)
  Person.create(name: 'Sanshiro Kariatsumari', gender: 'M', alive: false, birth: '1906-11-10',
    kanji: '狩集三四郎', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Victorio Masashi Kariatsumari', gender: 'M', alive: true)
  Person.create(name: 'Jun Kariatsumari', gender: 'M', alive: true)
  Person.create(name: 'Chojiro Matsumoto', gender: 'M', alive: false)
  Person.create(name: 'Soe Matsumoto', gender: 'F', alive: false)
  Person.create(name: 'Waka Kariatsumari', gender: 'F', alive: false, birth: '1910-6-23', death: '1987-1-27',
    kanji: '狩集ワカ', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Norioki Kariatsumari', gender: 'M', alive: true, birth: '1935-12-24',
    kanji: '狩集教恩', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Masaru Kariatsumari', gender: 'M', alive: true, birth: '1941-3-30',
    kanji: '狩集優', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Minoru Kariatsumari', gender: 'M', alive: true, birth: '1947-3-6',
    kanji: '狩集稔', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Kayako Matsuhata', gender: 'F', alive: false, birth: '1949-5-21', death: '1983-2-23',
    kanji: '狩集かや子', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Yoriko Samoto', gender: 'F', alive: true, birth: '1943-12-31',
    kanji: '狩集ヨリ子', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Yasuo Kariatsumari', gender: 'M', alive: true, birth: '1933-6-11',
    kanji: '狩集安夫', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Tsuneyoshi Kadota', gender: 'M', alive: false)
  Person.create(name: 'Haru Kadota', gender: 'F', alive: false)
  Person.create(name: 'Shoko Kariatsumari', gender: 'F', alive: true, birth: '1933-5-19',
    kanji: '狩集昌子', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Yasuyo Kariatsumari', gender: 'F', alive: true, birth: '1959-11-20',
    kanji: '狩集泰代', description: 'Miyazaki. Entrada no Rio de Janeiro em 14/08/1961 no navio Brasil Maru')
  Person.create(name: 'Gensaku Ikeda', gender: 'M', alive: false, birth: '1876-1-1',
    kanji: '池田 源作', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Mon Ikeda', gender: 'F', alive: false, birth: '1884-1-1',
    kanji: '池田 モン', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Soichi Ikeda', gender: 'M', alive: false, birth: '1906-1-1',
    kanji: '池田莊一', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Tomoji Ikeda', gender: 'M', alive: false, birth: '1911-1-1',
    kanji: '池田友治', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Ushimatsu Ikeda', gender: 'M', alive: false, birth: '1913-1-1',
    kanji: '池田丑松', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Shiro Ikeda', gender: 'M', alive: false, birth: '1918-1-1',
    kanji: '池田四郎', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Koharu Ikeda', gender: 'F', alive: false, birth: '1908-1-1',
    kanji: '池田小春', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Dia e mes de nascimento desconhecido')
  Person.create(name: 'Toyoko Murasawa', gender: 'F', alive: false, birth: '1915-11-13', death: '1979-9-23',
    kanji: '池田豊子', description: 'Osaka. Entrada em Santos/SP em 31 de julho de 1924 no navio Canada Maru. ' \
    'Faleceu em São Paulo/SP')
  Person.create(name: 'Setsu Yamazaki', gender: 'F', alive: false, birth: '1910-8-7',
    kanji: '山崎セツ', description: 'Tokyo. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Bunzo Yamazaki', gender: 'M', alive: false, birth: '1912-11-19',
    kanji: '山崎文藏', description: 'Toyama. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Seikichi Sekiya', gender: 'M', alive: false, birth: '1869-10-18',
    kanji: '關矢淸吉', description: 'Tokyo. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Kiyoshi Sekiya', gender: 'M', alive: false, birth: '1908-3-24',
    kanji: '關矢淸', description: 'Tokyo. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Shoji Sekiya', gender: 'M', alive: false, birth: '1909-2-3',
    kanji: '關矢正司', description: 'Tokyo. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Ei Sekiya', gender: 'F', alive: false, birth: '1864-6-8',
    kanji: '關矢ゑい', description: 'Tokyo. Entrada em Santos/SP em 03 de maio de 1932 no navio Santos Maru')
  Person.create(name: 'Sem cadastro Uemoto', gender: 'M', alive: false)
  Person.create(name: 'Sem cadastro Inoue 1', gender: 'M', alive: false)
  Person.create(name: 'Sem cadastro Inoue 2', gender: 'F', alive: false)
  Person.create(name: 'Sem cadastro Sekiya', gender: 'F', alive: false)
  Person.create(name: 'Sem cadastro Tabuti 1', gender: 'M', alive: false)
  Person.create(name: 'Sem cadastro Tabuti 2', gender: 'F', alive: true)
  Person.create(name: 'Marcos Yutaka Tabuti', gender: 'M', alive: true, description: 'Aniversário 19/08')
  Person.create(name: 'Rogério Yukio Tabuti', gender: 'M', alive: true, birth: '1967-10-14')
  Person.create(name: 'Márcia Mie Sericaku Tabuti', gender: 'F', alive: true, description: 'Aniversário 02/08')
  Person.create(name: 'Riichi Akiyoshi', gender: 'M', alive: false, birth: '1882-11-2',
    kanji: '秋吉利市', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Yone Akiyoshi', gender: 'F', alive: false, birth: '1889-5-31',
    kanji: '秋吉ヨ子', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Shikato Akiyoshi', gender: 'M', alive: false, birth: '1910-3-11',
    kanji: '秋吉鹿人', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Hiromi Akiyoshi', gender: 'F', alive: false, birth: '1913-12-5',
    kanji: '秋吉弘見', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Midori Fujiwara', gender: 'F', alive: false, birth: '1919-5-25',
    kanji: '秋吉ミドリ', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Kaoru Akiyoshi', gender: 'F', alive: false, birth: '1921-4-3',
    kanji: '秋吉カヲル', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Mitsuka Akiyoshi', gender: 'F', alive: false, birth: '1922-9-17',
    kanji: '秋吉ミツカ', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Hatsumi Akiyoshi', gender: 'F', alive: false, birth: '1927-3-10',
    kanji: '秋吉ハツミ', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Iwao Akiyoshi', gender: 'M', alive: false, birth: '1928-11-18',
    kanji: '秋吉巖', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Yoshiro Akiyoshi', gender: 'M', alive: false, birth: '1925-3-27', death: '1992-8-3',
    kanji: '秋吉義郎', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Shigeo Akiyoshi', gender: 'M', alive: false, birth: '1917-3-19',
    kanji: '秋吉繁雄', description: 'Fukuoka. Entrada em Santos/SP em 19/10/1929 no navio Kawachi Maru')
  Person.create(name: 'Tatsuo Ono', gender: 'M', alive: false, birth: '1921-1-11',
    kanji: '大野龍夫', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Masuko Yoshida', gender: 'F', alive: false, birth: '1919-1-30',
    kanji: '大野增子', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Hideko Takaki', gender: 'F', alive: false, birth: '1924-9-15',
    kanji: '大野日出子', description: 'Shimane. Entrada em Santos/SP em 27/05/1933 no navio Africa Maru')
  Person.create(name: 'Tsunahiko Shimada', gender: 'M', alive: false, birth: '1893-8-10',
    kanji: '嶋田綱彥', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Matsu Shimada', gender: 'F', alive: false, birth: '1896-6-16',
    kanji: '嶋田マツ', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Kaneo Shimada', gender: 'M', alive: false, birth: '1918-7-21',
    kanji: '嶋田兼夫', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Fusao Shimada', gender: 'M', alive: false, birth: '1927-7-2',
    kanji: '嶋田房夫', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Fumi Shimada', gender: 'F', alive: false, birth: '1916-10-29',
    kanji: '嶋田フミ', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Soe Aoki', gender: 'F', alive: false, birth: '1923-2-28',
    kanji: '嶋田ソエ', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Tsuruko Goto', gender: 'F', alive: true, birth: '1931-12-20',
    kanji: '嶋田ツル子', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Kuni Shimada', gender: 'F', alive: false, birth: '1920-8-17',
    kanji: '木下 クニ', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru. ' \
    'Veio do Japão adotada pela família Kinoshita (Tadao Kinoshita (木下忠雄) e Hisa Fujimoto (木下ヒサ)).')
  Person.create(name: 'Minoru Shimada', gender: 'M', alive: false, birth: '1912-2-25',
    kanji: '嶋田實', description: 'Kumamoto. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Sem cadastro Shimada 1', gender: 'M', alive: false)
  Person.create(name: 'Sem cadastro Shimada 2', gender: 'F', alive: false)
  Person.create(name: 'Yutaka Goto', gender: 'M', alive: false)
  Person.create(name: 'Hamazo Shimada', gender: 'M', alive: false)
  Person.create(name: 'Etsu Shimada', gender: 'F', alive: false)
  Person.create(name: 'Evandro Pereira de Mattos', gender: 'M', alive: true, birth: '1988-5-2')
  Person.create(name: 'Evandro Ranzoni Mattos', gender: 'M', alive: true, birth: '2021-12-20')
  Person.create(name: 'Lou Miyahara', gender: 'P', alive: true, birth: '2011-1-22')
  Person.create(name: 'Toby Miyahara', gender: 'P', alive: true)
  Person.create(name: 'Yuzu Miyahara', gender: 'F', alive: true, birth: '2021-10-22')
  Person.create(name: 'Olga Hiromi Yokoyama', gender: 'F', alive: true, birth: '1958-2-5', description: 'São Paulo/SP')
  Person.create(name: 'Walter Hitoshi Yokoyama', gender: 'M', alive: true, birth: '1952-11-13', description: 'Lucélia/SP')
  Person.create(name: 'Yosohachi Yokoyama', gender: 'M', alive: false, birth: '1881-2-5',
    kanji: '橫山八十八', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Koto Yokoyama', gender: 'F', alive: false, birth: '1884-11-15',
    kanji: '橫山コト', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Tsukumo Yokoyama', gender: 'M', alive: false, birth: '1911-3-13', death: '1982-10-9',
    kanji: '橫山九十九', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Tsune Yokoyama', gender: 'F', alive: false, birth: '1916-12-12',
    kanji: '橫山ツネ', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Momohachi Yokoyama', gender: 'M', alive: false, birth: '1921-3-2',
    kanji: '橫山百八', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Mihachiro Yokoyama', gender: 'M', alive: false, birth: '1929-3-13',
    kanji: '橫山已八郎', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Denji Yokoyama', gender: 'M', alive: true, birth: '1933-10-20',
    kanji: '橫山傳次', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Momojiro Yokoyama', gender: 'M', alive: false, birth: '1916-2-25',
    kanji: '橫山百治郎', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Masano Yokoyama', gender: 'F', alive: false, birth: '1917-12-24',
    kanji: '橫山マサノ', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Satono Yokoyama Muramatsu', gender: 'F', alive: false, birth: '1923-9-23',
    kanji: '橫山サトノ', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Tsunematsu Ogaki', gender: 'M', alive: false, birth: '1891-2-10',
    kanji: '大柿常松', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Naka Ogaki', gender: 'F', alive: false,
    kanji: '大柿ナカ', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Mitsuru Ogaki', gender: 'M', alive: false, birth: '1919-3-25',
    kanji: '大柿滿', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Minoru Ogaki', gender: 'M', alive: false, birth: '1922-9-15',
    kanji: '大柿實', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Kie Ogaki Tongu', gender: 'F', alive: false, birth: '1928-2-15',
    kanji: '大柿喜江', description: 'Fukushima. Entrada em Santos/SP em 31/08/1934 no navio Montevideo Maru')
  Person.create(name: 'Yuki Ogaki', gender: 'F', alive: false, birth: '1926-5-1')
  Person.create(name: 'Minosuke Morota', gender: 'M', alive: false, birth: '1969-8-9',
    kanji: '師田美之助', description: 'Hokkaido. Entrada em Santos/SP em 20/05/1919 no navio Sanuki Maru')
  Person.create(name: 'Chiyo Morota', gender: 'F', alive: false,
    kanji: '師田ちよ', description: 'Hokkaido. Entrada em Santos/SP em 20/05/1919 no navio Sanuki Maru')
  Person.create(name: 'Kiyoshi Morota', gender: 'M', alive: false, birth: '1920-9-12', description: 'Iguape/SP')
  Person.create(name: 'Hidekichi Suwa', gender: 'M', alive: false, birth: '1890-8-21',
    kanji: '諏訪秀吉', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Hiro Suwa', gender: 'F', alive: false, birth: '1898-5-11',
    kanji: '諏訪ヒロ', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Jitaro Suwa', gender: 'M', alive: false, birth: '1855-1-1',
    description: 'Aichi. Dia e mes de nascimento desconhecidos')
  Person.create(name: 'Chika Suwa', gender: 'F', alive: false, birth: '1860-1-1',
    description: 'Aichi. Dia e mes de nascimento desconhecidos')
  Person.create(name: 'Yodaemon Matsuda', gender: 'M', alive: false)
  Person.create(name: 'Sato Matsuda', gender: 'F', alive: false)
  Person.create(name: 'Senmatsu Honda', gender: 'M', alive: false)
  Person.create(name: 'Bunji Honda', gender: 'M', alive: false, birth: '1925-9-20',
    kanji: '本多文二', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Tsuguo Suwa', gender: 'M', alive: false, birth: '1920-4-13',
    kanji: '諏訪次夫', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Noboru Suwa', gender: 'M', alive: false, birth: '1928-8-22',
    kanji: '諏訪昇', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Hisako Suwa', gender: 'F', alive: true, birth: '1936-8-12',
    kanji: '諏訪久子', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Fumihiko Honda', gender: 'M', alive: false, birth: '1919-7-23',
    kanji: '本多文彥', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Eiko Suwa Morota', gender: 'F', alive: false, birth: '1927-12-20',
    kanji: '本多榮子', description: 'Osaka. Entrada em Santos/SP em 09/08/1937 no navio La Plata Maru')
  Person.create(name: 'Hana Suzuki Honda', gender: 'F', alive: false, birth: '1926-11-30',
    kanji: '鈴木ハナ', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Paulo Miquio Honda', gender: 'M', alive: true, birth: '1948-2-21', description: 'Guarulhos/SP')
  Person.create(name: 'Sogoro Suzuki', gender: 'M', alive: false, birth: '1901-9-20',
    kanji: '鈴木惣五郎', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Tamano Suzuki', gender: 'F', alive: false, birth: '1902-8-8',
    kanji: '鈴木タマノ', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Nisoji Takahashi', gender: 'M', alive: false)
  Person.create(name: 'Saki Takahashi', gender: 'F', alive: false)
  Person.create(name: 'Chukichi Suzuki', gender: 'M', alive: true, birth: '1933-10-8',
    kanji: '鈴木忠吉', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru ' \
    'Santos/SP 01/08/1934')
  Person.create(name: 'Sokichi Suzuki', gender: 'M', alive: false, birth: '1931-1-14',
    kanji: '鈴木惣吉', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Hama Suzuki Taira', gender: 'F', alive: false, birth: '1924-4-22',
    kanji: '鈴木ハマ', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Kuni Suzuki', gender: 'F', alive: false, birth: '1921-10-18',
    kanji: '鈴木クニ', description: 'Yamagata. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Jyroemon Morota', gender: 'M', alive: false)
  Person.create(name: 'Yae Morota', gender: 'F', alive: false)
  Person.create(name: 'Toyome Satake', gender: 'F', alive: false, birth: '1913-12-27',
    description: 'Entrada em Santos/SP em 18/08/1964 no navio')
  Person.create(name: 'Antonio Yokoyama', gender: 'M', alive: false, birth: '1974-11-10',
    description: 'Faleceu em Londrina/PR')
  Person.create(name: 'Kenda Hirata', gender: 'M', alive: false, birth: '1916-3-15',
    kanji: '平田健太', description: 'Fukuoka. Entrada em Santos/SP em 01/08/1934 no navio Rio de Janeiro Maru')
  Person.create(name: 'Hatsuko Hirata', gender: 'F', alive: false, birth: '1924-11-21',
    kanji: '稲富ハツ子', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Luiza Emiko Hirata', gender: 'F', alive: true, birth: '1947-7-23')
  Person.create(name: 'Kentaro Hirata', gender: 'M', alive: false, birth: '1880-5-15',
    kanji: '平田兼太郎', description: 'Fukuoka. Entrada em Santos/SP em 29/12/1935 no navio La Plata Maru')
  Person.create(name: 'Kin Hirata', gender: 'F', alive: false, birth: '1886-12-5',
    kanji: '平田キン', description: 'Fukuoka. Entrada em Santos/SP em 29/12/1935 no navio La Plata Maru')
  Person.create(name: 'Eitaro Inatomi', gender: 'M', alive: false, birth: '1905-3-5',
    kanji: '稻富榮太郎', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Muneyo Inatomi', gender: 'F', alive: false, birth: '1892-12-5', death: '1983-12-8',
    kanji: '稻富ム子ヨ', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru. ' \
    'Faleceu em Curitiba/PR')
  Person.create(name: 'Kiri Inatomi', gender: 'F', alive: false, birth: '1865-6-10',
    kanji: '稻富キリ', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Kiyota Inatomi', gender: 'M', alive: false, birth: '1911-4-27',
    kanji: '稻富淸太', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Rikita Inatomi', gender: 'M', alive: false, birth: '1915-9-17', death: '1987-1-9',
    kanji: '稻富力太', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Masato Inatomi', gender: 'M', alive: false, birth: '1918-7-23',
    kanji: '稻富正人', description: 'Fukuoka. Entrada em Santos/SP em 29/11/1933 no navio La Plata Maru')
  Person.create(name: 'Masako Inatomi', gender: 'M', alive: false)
  Person.create(name: 'Fujiko Inatomi', gender: 'F', alive: false, birth: '1920-4-14', death: '2015-2-15',
    description: 'Iguape/SP. Faleceu em Presidente Venceslau/SP')
  Person.create(name: 'José Yokio Inatomi', gender: 'M', alive: false, birth: '1943-11-25',
    description: 'Presidente Venceslau/SP')
  Person.create(name: 'Tsuyoshi Inatomi', gender: 'M', alive: false, birth: '1921-2-28', description: 'Fukuoka')
  Person.create(name: 'Takeo Inatomi', gender: 'M', alive: true, birth: '1935-8-26',
    description: 'Santa Cruz do Rio Pardo/SP')
  Person.create(name: 'Masataro Naito', gender: 'M', alive: false, birth: '1865-1-1',
    description: 'Dia e mes do nascimento desconhecido')
  Person.create(name: 'Shitsu Naito', gender: 'F', alive: false, birth: '1870-1-1',
    description: 'Dia e mes do nascimento desconhecido')
  Person.create(name: 'Luiz Shigueo Inatomi', gender: 'M', alive: false, birth: '1952-11-11', death: '1993-6-9',
    description: 'Presidente Venceslau. Faleceu em São Paulo/SP')
  Person.create(name: 'Ana Lucia Chaves', gender: 'F', alive: true)
  Person.create(name: 'Felipe', gender: 'M', alive: true)
  Person.create(name: 'Katsutaro Inatomi', gender: 'M', alive: false, birth: '1860-1-1',
    description: 'Dia e mes do nascimento desconhecido')
  Person.create(name: 'Teru Inatomi', gender: 'F', alive: false, birth: '1915-10-25', death: '1958-2-3',
    kanji: '馬郡テル', description: 'Saga. Entrada em Santos/SP em 07/07/1928 no navio Santos Maru. Faleceu em Curitiba/PR')
  Person.create(name: 'Tetsuji Magori', gender: 'M', alive: false, birth: '1917-7-31',
    kanji: '馬郡鐵次', description: 'Saga. Entrada em Santos/SP em 07/07/1928 no navio Santos Maru')
  Person.create(name: 'Katsuzo Magori', gender: 'M', alive: false, birth: '1891-1-1',
    description: 'Dia e mes do nascimento desconhecido')
  Person.create(name: 'Tsui Magori', gender: 'F', alive: false, birth: '1895-1-1',
    description: 'Dia e mes do nascimento desconhecido')
  Person.create(name: 'Bruno Kamogawa', gender: 'M', alive: true)
  Person.create(name: 'Guilherme Seiji Kamogawa', gender: 'M', alive: true)
  Person.create(name: 'Eduardo Kamogawa', gender: 'M', alive: true)
  Person.create(name: 'Patrícia Sales Patrício', gender: 'F', alive: true)
  Person.create(name: 'Norio', gender: 'M', alive: true)
  Person.create(name: 'Clara Mayumi Heira', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Akamine', gender: 'M', alive: true)
  Person.create(name: 'Rodrigo Akamine', gender: 'M', alive: true)
  Person.create(name: 'Gabriela Akamine', gender: 'F', alive: true)
  Person.create(name: 'Leo Tanabe', gender: 'M', alive: true)
  Person.create(name: 'Melissa Chikazawa', gender: 'F', alive: true)
  Person.create(name: 'Marcos Ouki', gender: 'M', alive: true)
  Person.create(name: 'Giovana Eiko Ouki', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Ouki', gender: 'M', alive: true)
  Person.create(name: 'Vinicius', gender: 'M', alive: true)
  Person.create(name: 'Kazuhiko', gender: 'M', alive: true)
  Person.create(name: 'Alex Ezoe', gender: 'M', alive: true)
  Person.create(name: 'Andressa', gender: 'F', alive: true)
  Person.create(name: 'Lucia Maria Carneiro', gender: 'F', alive: true)
  Person.create(name: 'Silvio da Silva de Oliveira', gender: 'M', alive: true)
  Person.create(name: 'Kauane Otake Ribeiro da Silva', gender: 'F', alive: true, birth: '2001-6-4')
  Person.create(name: 'Larissa Bini Garcia Otake', gender: 'F', alive: true, birth: '2010-1-20')
  Person.create(name: 'Gabriella Duarte Ribeiro Silva', gender: 'F', alive: true, birth: '2003-6-1')
  Person.create(name: 'Yuji Sakamoto', gender: 'M', alive: true, birth: '1968-8-18', description: 'Panorama')
  Person.create(name: 'Eduardo Nakabayashi', gender: 'M', alive: true)
  Person.create(name: 'Elaine', gender: 'F', alive: true)
  Person.create(name: 'Manu', gender: 'F', alive: true)
  Person.create(name: 'Maria Miyoko', gender: 'F', alive: true)
  Person.create(name: 'Michela', gender: 'F', alive: true)
  Person.create(name: 'Gustavo', gender: 'M', alive: true)
  Person.create(name: 'Mônica', gender: 'F', alive: true)
  Person.create(name: 'Katia Maeda Kanoski', gender: 'F', alive: true, description: 'Família Kanosuke')
  Person.create(name: 'Amanda', gender: 'F', alive: true)
  Person.create(name: 'Alberto Nakamura', gender: 'M', alive: true, birth: '1975-10-31', description: 'São Paulo/SP')
  Person.create(name: 'Shigeo Yamazaki', gender: 'M', alive: true)
  Person.create(name: 'Ekizo Nakao', gender: 'M', alive: false, birth: '1879-1-1',
    kanji: '中尾 易藏', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Tome Nakao', gender: 'F', alive: false, birth: '1886-1-1',
    kanji: '中尾 トメ', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Yasuo Nakao', gender: 'M', alive: false, birth: '1904-1-1',
    kanji: '中尾 安雄', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Takataro Matsumoto', gender: 'M', alive: false)
  Person.create(name: 'Yutaka Nakao', gender: 'M', alive: false, birth: '1912-1-1',
    kanji: '中尾 豊', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Akira Nakao', gender: 'M', alive: false, birth: '1914-1-1',
    kanji: '中尾 明', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Harumi Nakao', gender: 'M', alive: false, birth: '1920-1-1',
    kanji: '中尾 春美', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Shizue Nakao', gender: 'F', alive: false, birth: '1923-1-1',
    kanji: '中尾 シヅエ', description: 'Saga. Entrada em Santos/SP em 31/08/1925 no navio Kawachi Maru. ' \
    'Conhecido somente o ano do nascimento')
  Person.create(name: 'Seiichi Taguchi', gender: 'M', alive: false, birth: '1885-2-26',
    kanji: '田口 静一', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Hatsu Taguchi', gender: 'F', alive: false, birth: '1900-1-18',
    kanji: '田口 はつ', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Masayoshi Taguchi', gender: 'M', alive: false, birth: '1921-6-22',
    kanji: '田口 正純', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Tadashi Taguchi', gender: 'M', alive: false, birth: '1923-10-31',
    kanji: '田口 正', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Mamoru Taguchi', gender: 'M', alive: false, birth: '1929-1-21',
    kanji: '田口 守', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Tamotsu Taguchi', gender: 'M', alive: false, birth: '1930-5-4',
    kanji: '田口 保', description: 'Tochigi. Chegada em Santos/SP em 24/08/1932 no navio Buenos Aires Maru')
  Person.create(name: 'Mirian', gender: 'F', alive: true)
  Person.create(name: 'Wilson', gender: 'M', alive: true)
  Person.create(name: 'Matsuo Tanaka', gender: 'M', alive: false, birth: '1916-7-18',
    kanji: '田中 松男', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Kunio Tanaka', gender: 'M', alive: false, birth: '1919-1-20',
    kanji: '田中 邦夫', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Teruo Tanaka', gender: 'M', alive: false, birth: '1925-8-21',
    kanji: '田中 輝夫', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Kasue Tanaka', gender: 'F', alive: false, birth: '1912-12-8',
    kanji: '田中 カスヱ', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Fusa Tanaka', gender: 'F', alive: false, birth: '1928-5-12',
    kanji: '田中 フサ', description: 'Hokkaido. Entrada em Santos/SP em 03/02/1933 no navio Buenos Aires Maru')
  Person.create(name: 'Sime Matsumoto', gender: 'F', alive: false)
  Person.create(name: 'Isabelly', gender: 'F', alive: true, birth: '2015-1-12')
  Person.create(name: 'José Ilson', gender: 'M', alive: false)
  Person.create(name: 'Sem cadastro Junji', gender: 'F', alive: true)
  Person.create(name: 'Cícero', gender: 'M', alive: true)
  Person.create(name: 'Sem cadastro Elina', gender: 'F', alive: true)
  Person.create(name: 'Yuji Yamamoto', gender: 'M', alive: true)
  Person.create(name: 'Rosemeire', gender: 'F', alive: true)
  Person.create(name: 'Mauro', gender: 'M', alive: true)
  Person.create(name: 'Camilla', gender: 'F', alive: true)
  Person.create(name: 'Eduardo', gender: 'M', alive: true)
  Person.create(name: 'Gislaine', gender: 'F', alive: true)
  Person.create(name: 'Daniela Sakamoto', gender: 'F', alive: true)
  Person.create(name: 'Lucas Sakamoto', gender: 'M', alive: true)
  Person.create(name: 'Ednei', gender: 'M', alive: true)
  Person.create(name: 'Luciane Yumi', gender: 'F', alive: true)
  Person.create(name: 'Rafaela', gender: 'F', alive: true)
  Person.create(name: 'Sem cadastro Mayumi', gender: 'M', alive: true)
  Person.create(name: 'Cristiane Mayumi', gender: 'F', alive: true)
  Person.create(name: 'Breno', gender: 'M', alive: true)
  Person.create(name: 'Chikashi Kondo', gender: 'M', alive: false, birth: '1897-5-25',
    kanji: '近藤 近', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru')
  Person.create(name: 'Hatsumi Kondo', gender: 'F', alive: false, birth: '1901-10-5',
    kanji: '近藤 ハツミ', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru. Família Ogata')
  Person.create(name: 'Sumie Kondo', gender: 'F', alive: false, birth: '1928-8-19',
    kanji: '近藤 すみゑ', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru')
  Person.create(name: 'Chikae Waragai', gender: 'F', alive: false, birth: '1931-2-18',
    kanji: '近藤 近江', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru')
  Person.create(name: 'Akira Kondo', gender: 'M', alive: false, birth: '1922-1-10',
    kanji: '近藤 晟', description: 'Fukuoka. Chegada em Santos/SP 01/10/1934 no navio La Plata Maru. Adotado')
  Person.create(name: 'Mitinoiti Kondo', gender: 'M', alive: false)
  Person.create(name: 'Torano Kondo', gender: 'F', alive: false)
  Person.create(name: 'Tamekichi Ogata', gender: 'M', alive: false)
  Person.create(name: 'Kikuno Ogata', gender: 'F', alive: false)
  Person.create(name: 'Claudio Teles Filho', gender: 'M', alive: true, birth: '1987-4-2')
  Person.create(name: 'Sem cadastro Juliana', gender: 'M', alive: true)
  Person.create(name: 'Camila Yumi Otake Maki', gender: 'F', alive: true, birth: '2008-4-11')
  Person.create(name: 'Rafaela Thiemi Otake Andrade', gender: 'F', alive: true, birth: '2013-7-2')
  Person.create(name: 'Sem cadastro Felipe', gender: 'F', alive: true)
  Person.create(name: 'Victor Felipe Nominato Otake', gender: 'M', alive: true, birth: '2014-9-14')
  Person.create(name: 'Michaele Francisbel Cunico Otake', gender: 'F', alive: true, birth: '1991-4-23')
  Person.create(name: 'Ryan Cunico Otake', gender: 'M', alive: true, birth: '2018-8-17')
  Person.create(name: 'Bryan Cunico Otake', gender: 'M', alive: true, birth: '2020-11-25')
  Person.create(name: 'Arielly da Silva Otake', gender: 'F', alive: true, birth: '1996-12-14')
  Person.create(name: 'Elio Tadashi Kazihara', gender: 'M', alive: true)
  Person.create(name: 'Tatsugoro Waragai', gender: 'M', alive: false, birth: '1921-8-10',
    description: 'Fukushima')
  Person.create(name: 'Sanju Waragai', gender: 'M', alive: false)
  Person.create(name: 'Gin Waragai', gender: 'F', alive: false)
  Person.create(name: 'Masaemon Sekito', gender: 'M', alive: false)
  Person.create(name: 'Tome Sekito', gender: 'F', alive: false)
  Person.create(name: 'Monjiro Maruo', gender: 'M', alive: false)
  Person.create(name: 'Tora Maruo', gender: 'F', alive: false)
  Person.create(name: 'Sueichi Fujisawa', gender: 'M', alive: false)
  Person.create(name: 'Yukino Fujisawa', gender: 'F', alive: false)
  Person.create(name: 'Kátia Lie Sakamoto', gender: 'F', alive: true, birth: '1966-9-6', description: 'Dracena')
  Person.create(name: 'Lourdes Koroshue Sakamoto', gender: 'F', alive: false)
  Person.create(name: 'Nobuichi Koroshue', gender: 'M', alive: false)
  Person.create(name: 'Asako Sezaki', gender: 'F', alive: false)
  Person.create(name: 'Hidetaro Kuraba', gender: 'M', alive: false)
  Person.create(name: 'Sigeco Nakashima Kuraba', gender: 'F', alive: false)
  Person.create(name: 'Shigueyoshi Nakamura', gender: 'M', alive: false)
  Person.create(name: 'Kiku Nakamura', gender: 'F', alive: false)
  Person.create(name: 'Curt Neumann', gender: 'M', alive: false, birth: '1948-8-4', description: 'Blumenau/SC')
  Person.create(name: 'Kurt Wernar Neumann', gender: 'M', alive: false)
  Person.create(name: 'Ana Ruth Neumann', gender: 'F', alive: false)
  Person.create(name: 'Shiyuki Yamada', gender: 'F', birth: '2022-02-02', kanji: '梓由希')
  Person.create(name: 'Marina Todaki', gender: 'F')
end

unless Couple.any?
  couple = Couple.create!(person1_id: Person.find_by_name('Takashi Sakamoto').id, person2_id: Person.find_by_name('Chiyo Sakamoto').id, marriage: '1941-2-28')
  couple.people << Person.find_by_name('Satiye Sakamoto Otake')
  couple.people << Person.find_by_name('Tetuo Nakabaiashi Sakamoto')
  couple.people << Person.find_by_name('Armando Massao Sakamoto')
  couple.people << Person.find_by_name('Julio Minor Sakamoto')
  couple.people << Person.find_by_name('Helena Yoriko Ueno')
  couple.people << Person.find_by_name('Emilia Setuko Sakamoto')
  couple.people << Person.find_by_name('Alice Sakamoto')
  couple.people << Person.find_by_name('Marina Sakamoto')
  couple.people << Person.find_by_name('Sergio Hiroshi Sakamoto')
  couple.people << Person.find_by_name('Pety')
  couple = Couple.create!(person1_id: Person.find_by_name('Kiku Sakamoto').id, person2_id: Person.find_by_name('Kenji Sakamoto').id)
  couple.people << Person.find_by_name('Takashi Sakamoto')
  couple.people << Person.find_by_name('Tikashi Sakamoto')
  couple.people << Person.find_by_name('Asa Yamazaki')
  couple.people << Person.find_by_name('Tani Yamazaki')
  couple.people << Person.find_by_name('Rikizo Sakamoto')
  couple.people << Person.find_by_name('Yoshio Sakamoto')
  couple.people << Person.find_by_name('Toshio Sakamoto')
  couple.people << Person.find_by_name('Michio Sakamoto')
  couple.people << Person.find_by_name('Tomihide Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Tetuo Nakabaiashi Sakamoto').id, person2_id: Person.find_by_name('Hetsuko Sakamoto').id, marriage: '1975-1-16')
  couple.people << Person.find_by_name('Rodrigo Eiji Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Armando Massao Sakamoto').id, person2_id: Person.find_by_name('Silvia Aparecida de Brito Sakamoto').id, marriage: '1972-7-22')
  couple.people << Person.find_by_name('Ana Rita Sakamoto')
  couple.people << Person.find_by_name('Roberta Maria Sakamoto Thomazelli')
  couple.people << Person.find_by_name('Marta Regina Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Julio Minor Sakamoto').id, person2_id: Person.find_by_name('Lucia Fernandes Mello Sakamoto').id, marriage: '1981-9-5')
  couple.people << Person.find_by_name('Mariana Mieko Sakamoto')
  couple.people << Person.find_by_name('Daniel Hideki Sakamoto')
  couple.people << Person.find_by_name('Thiago Tomio Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Sergio Hiroshi Sakamoto').id, person2_id: Person.find_by_name('Miyoko Koshimizu').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sonoi Nakabayashi').id, person2_id: Person.find_by_name('Torajiro Nakabayashi').id)
  couple.people << Person.find_by_name('Chiyo Sakamoto')
  couple.people << Person.find_by_name('Yasujiro Nakabayashi')
  couple.people << Person.find_by_name('Tiyo')
  couple.people << Person.find_by_name('Kiyo')
  couple.people << Person.find_by_name('Takeo Nakabayashi')
  couple.people << Person.find_by_name('Hideo Nakabayashi')
  couple.people << Person.find_by_name('Shokiti Nakabayashi')
  couple.people << Person.find_by_name('Miyo Nakabayashi Missu')
  couple.people << Person.find_by_name('Nobu Shimada')
  couple.people << Person.find_by_name('Hatsue Tanaka')
  couple = Couple.create!(person1_id: Person.find_by_name('Satiye Sakamoto Otake').id, person2_id: Person.find_by_name('Akira Otake').id, marriage: '1962-5-12')
  couple.people << Person.find_by_name('Marcio Kazunori Otake')
  couple.people << Person.find_by_name('Regina Harumi Otake Miura')
  couple.people << Person.find_by_name('Elson Akio Otake')
  couple.people << Person.find_by_name('Cristina Akemi Otake')
  couple.people << Person.find_by_name('Suzi')
  couple.people << Person.find_by_name('Tibi')
  couple = Couple.create!(person1_id: Person.find_by_name('Takeo Yonekubo').id, person2_id: Person.find_by_name('Omine Yonekubo').id)
  couple.people << Person.find_by_name('Moyo Yonekubo Otake')
  couple.people << Person.find_by_name('Shigeo Yonekubo')
  couple.people << Person.find_by_name('Takashi Yonekubo')
  couple.people << Person.find_by_name('Fusako Nagashima')
  couple = Couple.create!(person1_id: Person.find_by_name('Takeo Yonekubo').id, person2_id: Person.find_by_name('Mao Yonekubo').id)
  couple.people << Person.find_by_name('Hideko Nishida')
  couple.people << Person.find_by_name('Mariko Ikeda')
  couple = Couple.create!(person1_id: Person.find_by_name('Yutaka Otake').id, person2_id: Person.find_by_name('Luzinete Carneiro da Silva Otake').id, marriage: '1984-11-17')
  couple.people << Person.find_by_name('Reiko Claudia Otake')
  couple.people << Person.find_by_name('Mayumi Tais Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Yutaka Otake').id, person2_id: Person.find_by_name('Joana Gonçalves de Almeida').id, marriage: '1957-1-14')
  couple.people << Person.find_by_name('Flávio Antônio Otake')
  couple.people << Person.find_by_name('Fabio Hamilton Otake')
  couple.people << Person.find_by_name('Eiko Cristina Otake')
  couple.people << Person.find_by_name('Francisco Fernando Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Elson Akio Otake').id, person2_id: Person.find_by_name('Helena Ayako Kariatsumari Otake').id, marriage: '1995-2-4', separation: '2007-2-4')
  couple = Couple.create!(person1_id: Person.find_by_name('Elson Akio Otake').id, person2_id: Person.find_by_name('Lilian Hiromi Job').id, marriage: '2017-3-25')
  couple.people << Person.find_by_name('Luna')
  couple = Couple.create!(person1_id: Person.find_by_name('Regina Harumi Otake Miura').id, person2_id: Person.find_by_name('Jorge Miura').id, marriage: '2000-9-16')
  couple.people << Person.find_by_name('Tatiana Mitie Miura')
  couple = Couple.create!(person1_id: Person.find_by_name('Iracema Otake dos Santos').id, person2_id: Person.find_by_name('Adalberto Santos Braga').id, marriage: '1962-9-22')
  couple.people << Person.find_by_name('Sandra Meyre Otake dos Santos Miyahara')
  couple.people << Person.find_by_name('Sergio Roberto Otake dos Santos')
  couple.people << Person.find_by_name('Catia Regina Otake dos Santos')
  couple = Couple.create!(person1_id: Person.find_by_name('Sandra Meyre Otake dos Santos Miyahara').id, person2_id: Person.find_by_name('Joaquim Carlos Ranzoni').id)
  couple.people << Person.find_by_name('Caroline Ranzoni')
  couple = Couple.create!(person1_id: Person.find_by_name('Sandra Meyre Otake dos Santos Miyahara').id, person2_id: Person.find_by_name('Andre Akiyoshi Miyahara').id, marriage: '2001-5-18')
  couple.people << Person.find_by_name('Andre Akiyoshi Miyahara Jr.')
  couple.people << Person.find_by_name('Lou Miyahara')
  couple.people << Person.find_by_name('Toby Miyahara')
  couple = Couple.create!(person1_id: Person.find_by_name('Carmen Hisako Nakaji').id, person2_id: Person.find_by_name('Sanzan Nakaji').id)
  couple.people << Person.find_by_name('Claudia Sayuri Tokuda')
  couple.people << Person.find_by_name('Cristina Emi Nakaji')
  couple = Couple.create!(person1_id: Person.find_by_name('Claudia Sayuri Tokuda').id, person2_id: Person.find_by_name('Augusto Tokuda').id)
  couple.people << Person.find_by_name('Lucas Mitsuharo Tokuda')
  couple.people << Person.find_by_name('Leticia Miwa Tokuda')
  couple = Couple.create!(person1_id: Person.find_by_name('Flávio Antônio Otake').id, person2_id: Person.find_by_name('Elizete Volpe Otake').id)
  couple.people << Person.find_by_name('Flavia Otake')
  couple.people << Person.find_by_name('Fabiano Otake')
  couple.people << Person.find_by_name('Igor Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabio Hamilton Otake').id, person2_id: Person.find_by_name('Ana Maria da Cruz').id)
  couple.people << Person.find_by_name('Fabiana da Cruz Otake')
  couple.people << Person.find_by_name('Juliana da Cruz Otake')
  couple.people << Person.find_by_name('Fabio da Cruz Otake')
  couple.people << Person.find_by_name('Felipe da Cruz Otake')
  couple.people << Person.find_by_name('Fatima Maria da Cruz')
  couple = Couple.create!(person1_id: Person.find_by_name('Francisco Fernando Otake').id, person2_id: Person.find_by_name('Sandra Regina Otake').id)
  couple.people << Person.find_by_name('Amanda Takahashi Otake')
  couple.people << Person.find_by_name('Lucas Takahashi Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Rikizo Sakamoto').id, person2_id: Person.find_by_name('Teruko Maruo Sakamoto').id, marriage: '1943-7-26', local: 'Paulopolis')
  couple = Couple.create!(person1_id: Person.find_by_name('Rikizo Sakamoto').id, person2_id: Person.find_by_name('Haruko Fujisawa').id)
  couple.people << Person.find_by_name('Marie Sakamoto')
  couple.people << Person.find_by_name('Osamu Sakamoto')
  couple.people << Person.find_by_name('Junji Sakamoto')
  couple.people << Person.find_by_name('Satoru Sakamoto')
  couple.people << Person.find_by_name('Hiroko Sakamoto')
  couple.people << Person.find_by_name('Elina Sakamoto')
  couple.people << Person.find_by_name('Atsuko Yamamoto')
  couple.people << Person.find_by_name('Yuji Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Yoshio Sakamoto').id, person2_id: Person.find_by_name('Yoshie Sakamoto').id, marriage: '1944-5-13', local: 'Pompeia')
  couple.people << Person.find_by_name('Seyishi Sakamoto')
  couple.people << Person.find_by_name('Luiz Riyoji Sakamoto')
  couple.people << Person.find_by_name('Moriyaki Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Toshio Sakamoto').id, person2_id: Person.find_by_name('Tomi Sekito Sakamoto').id, marriage: '1955-7-9')
  couple.people << Person.find_by_name('Emiko')
  couple = Couple.create!(person1_id: Person.find_by_name('Michio Sakamoto').id, person2_id: Person.find_by_name('Yoko Kondo').id, marriage: '1956-11-28')
  couple.people << Person.find_by_name('Wilson Eidi Sakamoto')
  couple.people << Person.find_by_name('Nelson Takeshi Sakamoto')
  couple.people << Person.find_by_name('Alice Mizue Sakamoto')
  couple.people << Person.find_by_name('Milton Tsuyoshi Sakamoto')
  couple.people << Person.find_by_name('Sérgio Koji Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Yasujiro Nakabayashi').id, person2_id: Person.find_by_name('Fumi Nakabayashi').id)
  couple.people << Person.find_by_name('Toshie Barros')
  couple.people << Person.find_by_name('Cristina Kazue Sasaki')
  couple.people << Person.find_by_name('Marta Tomiko Rossi')
  couple.people << Person.find_by_name('Alice Shizue Viana')
  couple.people << Person.find_by_name('Jorge Yasunori Nakabayashi')
  couple.people << Person.find_by_name('Dirceu Mamoru Nakabayashi')
  couple.people << Person.find_by_name('Lincoln Satoru Nakabayashi')
  couple.people << Person.find_by_name('Kazue Sasaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Takeo Nakabayashi').id, person2_id: Person.find_by_name('Hiroko Nakabayashi').id)
  couple.people << Person.find_by_name('Julio Nakabayashi')
  couple.people << Person.find_by_name('Luisa Yukie Nakabayashi')
  couple.people << Person.find_by_name('Takeshi Nakabayashi')
  couple.people << Person.find_by_name('Takemi Nakabayashi')
  couple = Couple.create!(person1_id: Person.find_by_name('Hideo Nakabayashi').id, person2_id: Person.find_by_name('Yuriko Nakabayashi').id)
  couple.people << Person.find_by_name('Vaildo Hideyuki Nakabayashi')
  couple.people << Person.find_by_name('Valdir Hidenari Nakabayashi')
  couple.people << Person.find_by_name('Regina Etsuko Nakabayashi')
  couple.people << Person.find_by_name('Rosemary Yoko Nakabayashi')
  couple = Couple.create!(person1_id: Person.find_by_name('Emilia Setuko Sakamoto').id, person2_id: Person.find_by_name('Yaso Omi').id, marriage: '1985-9-15')
  couple.people << Person.find_by_name('Ricardo Sakamoto Omi')
  couple.people << Person.find_by_name('Juliana Sakamoto Omi')
  couple = Couple.create!(person1_id: Person.find_by_name('Yaso Omi').id, person2_id: Person.find_by_name('Ines Souza Pereira').id)
  couple.people << Person.find_by_name('Andre Katsuhiro Pereira Omi')
  couple = Couple.create!(person1_id: Person.find_by_name('Helena Yoriko Ueno').id, person2_id: Person.find_by_name('Keisso Ueno').id, marriage: '1975-7-12')
  couple.people << Person.find_by_name('Andre Toshio Ueno')
  couple.people << Person.find_by_name('Eduardo Mitio Ueno')
  couple.people << Person.find_by_name('Cristina Sayuri Ueno')
  couple = Couple.create!(person1_id: Person.find_by_name('Rodrigo Eiji Sakamoto').id, person2_id: Person.find_by_name('Jenifer Mori').id)
  couple.people << Person.find_by_name('Carolina Yukari Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Eiko Cristina Otake').id, person2_id: Person.find_by_name('Geraldo Manoel da Silva').id)
  couple.people << Person.find_by_name('Miriam Otake de Oliveira')
  couple.people << Person.find_by_name('Eliane')
  couple = Couple.create!(person1_id: Person.find_by_name('Shigeo Yonekubo').id, person2_id: Person.find_by_name('Kimiko Yonekubo').id)
  couple.people << Person.find_by_name('Kuniko')
  couple.people << Person.find_by_name('Haruko')
  couple.people << Person.find_by_name('Miyeko')
  couple.people << Person.find_by_name('Roberto Itiro Yonekubo')
  couple = Couple.create!(person1_id: Person.find_by_name('Takashi Yonekubo').id, person2_id: Person.find_by_name('Shizuko Yonekubo').id)
  couple.people << Person.find_by_name('Roberto Yonekubo')
  couple.people << Person.find_by_name('Rosangela')
  couple = Couple.create!(person1_id: Person.find_by_name('Hifumi Akiyoshi').id, person2_id: Person.find_by_name('Masayuki Akiyoshi').id, marriage: '1944-6-17', local: 'Uraí/PR')
  couple.people << Person.find_by_name('Reiko')
  couple.people << Person.find_by_name('Mitsuko')
  couple.people << Person.find_by_name('Sachiko')
  couple.people << Person.find_by_name('Toshio Akiyoshi')
  couple.people << Person.find_by_name('Mitsuo Akiyoshi')
  couple.people << Person.find_by_name('Masao Akiyoshi')
  couple.people << Person.find_by_name('Isao Akiyoshi')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsunesaburo Murase').id, person2_id: Person.find_by_name('Take (Murase) Otake').id)
  couple.people << Person.find_by_name('Yoshiaki Murase')
  couple.people << Person.find_by_name('Fusako Ota')
  couple.people << Person.find_by_name('Minoru (Murase) Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Yoshiaki Murase').id, person2_id: Person.find_by_name('Sumiko Murase').id)
  couple.people << Person.find_by_name('Shunji Murase')
  couple.people << Person.find_by_name('Osamu Murase')
  couple.people << Person.find_by_name('Shigeki Murase')
  couple = Couple.create!(person1_id: Person.find_by_name('Minoru (Murase) Otake').id, person2_id: Person.find_by_name('Kazue Otake').id)
  couple.people << Person.find_by_name('Hiromi Otake Henna')
  couple.people << Person.find_by_name('Yuriko Otake Perina')
  couple = Couple.create!(person1_id: Person.find_by_name('Hiromi Otake Henna').id, person2_id: Person.find_by_name('Tsuneo Henna').id)
  couple.people << Person.find_by_name('Alexandra Henna Abussanra')
  couple.people << Person.find_by_name('Daniela Henna')
  couple.people << Person.find_by_name('Carla Henna')
  couple = Couple.create!(person1_id: Person.find_by_name('Alexandra Henna Abussanra').id, person2_id: Person.find_by_name('Jose Elias Abussanra').id)
  couple.people << Person.find_by_name('Bruno Henna Abussanra')
  couple.people << Person.find_by_name('Mariana Henna Abussanra')
  couple = Couple.create!(person1_id: Person.find_by_name('Yuriko Otake Perina').id, person2_id: Person.find_by_name('Marcos Perina').id)
  couple.people << Person.find_by_name('Amanda Perina')
  couple.people << Person.find_by_name('Melissa Perina')
  couple = Couple.create!(person1_id: Person.find_by_name('Asakichi Yonekubo').id, person2_id: Person.find_by_name('Yatsue Yonekubo').id)
  couple.people << Person.find_by_name('Tadanori Yonekubo')
  couple.people << Person.find_by_name('Morimasa Yonekubo')
  couple.people << Person.find_by_name('Masato Yonekubo')
  couple.people << Person.find_by_name('Asako Yonekubo')
  couple.people << Person.find_by_name('Ayako Yonekubo')
  couple.people << Person.find_by_name('Shoko Yonekubo')
  couple = Couple.create!(person1_id: Person.find_by_name('Morimasa Yonekubo').id, person2_id: Person.find_by_name('Flora Uemoto Yonekubo').id, marriage: '1959-9-18', local: 'Pompéia/SP')
  couple = Couple.create!(person1_id: Person.find_by_name('Asako Yonekubo').id, person2_id: Person.find_by_name('Uda Kokichi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Eiko Cristina Otake').id, person2_id: Person.find_by_name('Sem cadastro Eiko').id)
  couple.people << Person.find_by_name('Tatiane Cristina Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Tetsuno Ono').id, person2_id: Person.find_by_name('Sakuichi Ono').id)
  couple.people << Person.find_by_name('Kazue Otake')
  couple.people << Person.find_by_name('Tatsuo Ono')
  couple.people << Person.find_by_name('Masuko Yoshida')
  couple.people << Person.find_by_name('Hideko Takaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Moyo Yonekubo Otake').id, person2_id: Person.find_by_name('Cho Otake').id)
  couple.people << Person.find_by_name('Akira Otake')
  couple.people << Person.find_by_name('Yutaka Otake')
  couple.people << Person.find_by_name('Carmen Hisako Nakaji')
  couple.people << Person.find_by_name('Iracema Otake dos Santos')
  couple = Couple.create!(person1_id: Person.find_by_name('Cho Otake').id, person2_id: Person.find_by_name('Yoshio Otake').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Fusako Nagashima').id, person2_id: Person.find_by_name('Fumio Nagashima').id)
  couple.people << Person.find_by_name('Helio Nagashima')
  couple.people << Person.find_by_name('Rosa')
  couple.people << Person.find_by_name('Helena')
  couple.people << Person.find_by_name('Maria')
  couple.people << Person.find_by_name('Tereza Simonaka')
  couple = Couple.create!(person1_id: Person.find_by_name('Helio Nagashima').id, person2_id: Person.find_by_name('Sem cadastro Nagashima').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Mao Yonekubo').id, person2_id: Person.find_by_name('Jonataro Shimodairo').id)
  couple.people << Person.find_by_name('Hifumi Akiyoshi')
  couple = Couple.create!(person1_id: Person.find_by_name('Hideko Nishida').id, person2_id: Person.find_by_name('Akira Nishida').id)
  couple.people << Person.find_by_name('Keiko')
  couple.people << Person.find_by_name('Tiemi')
  couple = Couple.create!(person1_id: Person.find_by_name('Mariko Ikeda').id, person2_id: Person.find_by_name('Goro Ikeda').id, marriage: '1953-3-12', local: 'Sorocaba/SP')
  couple.people << Person.find_by_name('Marie')
  couple.people << Person.find_by_name('Satie')
  couple = Couple.create!(person1_id: Person.find_by_name('Tami Otake').id, person2_id: Person.find_by_name('Yasutaro Otake').id)
  couple.people << Person.find_by_name('Take (Murase) Otake')
  couple.people << Person.find_by_name('Cho Otake')
  couple.people << Person.find_by_name('Sada Otake')
  couple.people << Person.find_by_name('Tsuya Usui')
  couple.people << Person.find_by_name('Ken Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Asa Yamazaki').id, person2_id: Person.find_by_name('Munenawo Yamazaki').id)
  couple.people << Person.find_by_name('Tomoko Yoshii Yamazaki')
  couple.people << Person.find_by_name('Naomatsu Yamazaki')
  couple.people << Person.find_by_name('Satoe Hatori')
  couple.people << Person.find_by_name('Sakiko Nakamura')
  couple.people << Person.find_by_name('Shigeo Yamazaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Tani Yamazaki').id, person2_id: Person.find_by_name('Soichiro Yamazaki').id)
  couple.people << Person.find_by_name('Soji Yamazaki')
  couple.people << Person.find_by_name('Marie Sato')
  couple = Couple.create!(person1_id: Person.find_by_name('Nobu Shimada').id, person2_id: Person.find_by_name('Yasuo Shimada').id)
  couple.people << Person.find_by_name('Ernesto Kazuo Shimada')
  couple.people << Person.find_by_name('Claudio Tsuguio Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Miyo Nakabayashi Missu').id, person2_id: Person.find_by_name('Mikiji Missu').id)
  couple.people << Person.find_by_name('Jorge Kotaro Misu')
  couple.people << Person.find_by_name('Leonardo Yukihiro Misu')
  couple.people << Person.find_by_name('Emilia Kimie Misu')
  couple.people << Person.find_by_name('Margarida Hiromi Misu Nakagawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Ernesto Kazuo Shimada').id, person2_id: Person.find_by_name('Rose Talma Shimada').id)
  couple.people << Person.find_by_name('Guilherme Ken Shimada')
  couple.people << Person.find_by_name('Fernanda Akemi Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Claudio Tsuguio Shimada').id, person2_id: Person.find_by_name('Clara Harue Shimada').id)
  couple.people << Person.find_by_name('Fabio Yasuo Shimada')
  couple.people << Person.find_by_name('Juliana Tiemi Shimada')
  couple.people << Person.find_by_name('Ivan Goro Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Andre Katsuhiro Pereira Omi').id, person2_id: Person.find_by_name('Maria Aparecida Azevedo').id)
  couple.people << Person.find_by_name('Barbara Azevedo Omi')
  couple.people << Person.find_by_name('Vinicius Azevedo Omi')
  couple = Couple.create!(person1_id: Person.find_by_name('Hatsue Tanaka').id, person2_id: Person.find_by_name('Tadashi Tanaka').id)
  couple.people << Person.find_by_name('Kazuko Tanaka')
  couple.people << Person.find_by_name('Leonardo Akira Tanaka')
  couple.people << Person.find_by_name('Luriko Tanaka')
  couple.people << Person.find_by_name('Helena Tanaka')
  couple = Couple.create!(person1_id: Person.find_by_name('Jorge Kotaro Misu').id, person2_id: Person.find_by_name('Helena Uemura Misu').id)
  couple.people << Person.find_by_name('Áurea Hisae Misu')
  couple.people << Person.find_by_name('Marcelo Mitsuo Misu')
  couple.people << Person.find_by_name('Marcos Haruo Misu')
  couple = Couple.create!(person1_id: Person.find_by_name('Leonardo Yukihiro Misu').id, person2_id: Person.find_by_name('Sem cadastro Yukihiro').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Margarida Hiromi Misu Nakagawa').id, person2_id: Person.find_by_name('Carlos Nakagawa').id)
  couple.people << Person.find_by_name('Cintia Yumi Nakagawa')
  couple.people << Person.find_by_name('Cristina Thiemy Nakagawa')
  couple.people << Person.find_by_name('Marcio Kendy Nakagawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Vaildo Hideyuki Nakabayashi').id, person2_id: Person.find_by_name('Sem cadastro Hideyuki').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Valdir Hidenari Nakabayashi').id, person2_id: Person.find_by_name('Sem cadastro Hidenari').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Rosemary Yoko Nakabayashi').id, person2_id: Person.find_by_name('Sem cadastro Rosemary').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Julio Nakabayashi').id, person2_id: Person.find_by_name('Shizue Nakabayashi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Soji Yamazaki').id, person2_id: Person.find_by_name('Emiko').id)
  couple.people << Person.find_by_name('Emi')
  couple.people << Person.find_by_name('Fabio Eiji Yamazaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Marie Sato').id, person2_id: Person.find_by_name('Nelson Sato').id)
  couple.people << Person.find_by_name('Wiliam Hiroshi Sato')
  couple.people << Person.find_by_name('Wellington Hitoshi Sato')
  couple = Couple.create!(person1_id: Person.find_by_name('Tomoko Yoshii Yamazaki').id, person2_id: Person.find_by_name('Masaaki Yoshii').id, marriage: '1957-12-21')
  couple.people << Person.find_by_name('Edson Yoshii')
  couple.people << Person.find_by_name('Rosemaly Naomi Tabuti')
  couple.people << Person.find_by_name('Roberto Akio Yoshii')
  couple.people << Person.find_by_name('Emilia Yoshii Nishimura')
  couple = Couple.create!(person1_id: Person.find_by_name('Edson Yoshii').id, person2_id: Person.find_by_name('Rosana Goncalves Yoshii').id)
  couple.people << Person.find_by_name('Tatiana Goncalves Yoshii')
  couple = Couple.create!(person1_id: Person.find_by_name('Naomatsu Yamazaki').id, person2_id: Person.find_by_name('Ayaka Yamazaki').id, marriage: '1967-12-16', local: 'Santo Amaro/SP')
  couple.people << Person.find_by_name('Reimi Yamazaki')
  couple.people << Person.find_by_name('Meire Yamazaki')
  couple.people << Person.find_by_name('Erica Yamazaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Naomatsu Yamazaki').id, person2_id: Person.find_by_name('Akemi Kinoshita').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Satoe Hatori').id, person2_id: Person.find_by_name('Shinzo Hatori').id)
  couple.people << Person.find_by_name('Eduardo Masaro Hatori')
  couple.people << Person.find_by_name('Fabio Katsumi Hatori')
  couple.people << Person.find_by_name('Elisa Mariko Hosaki')
  couple.people << Person.find_by_name('Sueli Hatori')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabio Katsumi Hatori').id, person2_id: Person.find_by_name('Sem cadastro Katsumi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sakiko Nakamura').id, person2_id: Person.find_by_name('Mitio Nakamura').id, marriage: '1965-1-21')
  couple.people << Person.find_by_name('Gilberto Shigeru Nakamura')
  couple.people << Person.find_by_name('Elisabeth Nakamura Kagohara')
  couple.people << Person.find_by_name('Janete Asami Sato')
  couple.people << Person.find_by_name('Alberto Nakamura')
  couple = Couple.create!(person1_id: Person.find_by_name('Miyoko Koshimizu').id, person2_id: Person.find_by_name('Jose Francisco Brides').id)
  couple.people << Person.find_by_name('Rodrigo Koshimizu')
  couple.people << Person.find_by_name('Fernanda Koshimizu')
  couple = Couple.create!(person1_id: Person.find_by_name('Rosemaly Naomi Tabuti').id, person2_id: Person.find_by_name('Francisco Nobuo Tabuti').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Yonekubo 2').id, person2_id: Person.find_by_name('Sem cadastro Yonekubo 1').id)
  couple.people << Person.find_by_name('Takeo Yonekubo')
  couple.people << Person.find_by_name('Asakichi Yonekubo')
  couple = Couple.create!(person1_id: Person.find_by_name('Jiro Tanaka').id, person2_id: Person.find_by_name('Miki Tanaka').id)
  couple.people << Person.find_by_name('Tadashi Tanaka')
  couple.people << Person.find_by_name('Fumi Nakabayashi')
  couple = Couple.create!(person1_id: Person.find_by_name('Roberto Akio Yoshii').id, person2_id: Person.find_by_name('Mitiko Yoshii').id)
  couple.people << Person.find_by_name('Renata Yumi Yoshii')
  couple = Couple.create!(person1_id: Person.find_by_name('Emilia Yoshii Nishimura').id, person2_id: Person.find_by_name('Roberto Nishimura').id)
  couple.people << Person.find_by_name('Fernando Nishimura')
  couple.people << Person.find_by_name('Henrique Nishimura')
  couple = Couple.create!(person1_id: Person.find_by_name('Erica Yamazaki').id, person2_id: Person.find_by_name('Sem cadastro Erica').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Meire Yamazaki').id, person2_id: Person.find_by_name('Sem cadastro Meire').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Elisa Mariko Hosaki').id, person2_id: Person.find_by_name('Sem cadastro Elisa').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sakiko Nakamura').id, person2_id: Person.find_by_name('Masaki Ogawa').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Janete Asami Sato').id, person2_id: Person.find_by_name('Helio Sato').id)
  couple.people << Person.find_by_name('Tiago Sato')
  couple.people << Person.find_by_name('Bruno Sato')
  couple = Couple.create!(person1_id: Person.find_by_name('Elisabeth Nakamura Kagohara').id, person2_id: Person.find_by_name('Jorge Kagohara').id)
  couple.people << Person.find_by_name('Karina Kagohara')
  couple.people << Person.find_by_name('Larissa Kagohara')
  couple = Couple.create!(person1_id: Person.find_by_name('Sato Yamazaki').id, person2_id: Person.find_by_name('Sobei Yamazaki').id)
  couple.people << Person.find_by_name('Munenawo Yamazaki')
  couple.people << Person.find_by_name('Soichiro Yamazaki')
  couple.people << Person.find_by_name('Bunzo Yamazaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Sada Otake').id, person2_id: Person.find_by_name('Hatsu Takada').id)
  couple.people << Person.find_by_name('Itsuo Otake')
  couple.people << Person.find_by_name('Kazuko Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Shunji Murase').id, person2_id: Person.find_by_name('Noriko Murase').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Osamu Murase').id, person2_id: Person.find_by_name('Masumi Murase').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Shigeki Murase').id, person2_id: Person.find_by_name('Rueko Murase').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Tsuya Usui').id, person2_id: Person.find_by_name('Shinajirou Usui').id)
  couple.people << Person.find_by_name('Toru Usui')
  couple.people << Person.find_by_name('Sadako Usui')
  couple.people << Person.find_by_name('Shogo Usui')
  couple.people << Person.find_by_name('Hideo Usui')
  couple.people << Person.find_by_name('Juji Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Toru Usui').id, person2_id: Person.find_by_name('Misao Usui').id)
  couple.people << Person.find_by_name('Kenichi Usui')
  couple.people << Person.find_by_name('Naoki Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Kenichi Usui').id, person2_id: Person.find_by_name('Sumako Narita').id)
  couple.people << Person.find_by_name('Daiki Usui')
  couple.people << Person.find_by_name('Chie Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Naoki Usui').id, person2_id: Person.find_by_name('Yasuyo Kondoh').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Shogo Usui').id, person2_id: Person.find_by_name('Tsuyako Fujimoto').id)
  couple.people << Person.find_by_name('Masaki Usui')
  couple.people << Person.find_by_name('Mami Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Hideo Usui').id, person2_id: Person.find_by_name('Mikie Gotoh').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Juji Usui').id, person2_id: Person.find_by_name('Kazuko Kishi').id)
  couple.people << Person.find_by_name('Yoshihiro Usui')
  couple.people << Person.find_by_name('Toshihiro Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Yoshihiro Usui').id, person2_id: Person.find_by_name('Sem cadastro Yoshihiro').id)
  couple.people << Person.find_by_name('Sem cadastro Outa 2')
  couple.people << Person.find_by_name('Outa Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Sadako Usui').id, person2_id: Person.find_by_name('Kazuo Kamiya').id)
  couple.people << Person.find_by_name('Keiko Kamiya')
  couple = Couple.create!(person1_id: Person.find_by_name('Keiko Kamiya').id, person2_id: Person.find_by_name('Tetsuhiro Honjoh').id)
  couple.people << Person.find_by_name('Yumi Honjoh')
  couple.people << Person.find_by_name('Yamato Honjoh')
  couple = Couple.create!(person1_id: Person.find_by_name('Masaki Usui').id, person2_id: Person.find_by_name('Chikage Nishihara').id)
  couple.people << Person.find_by_name('Yuh Usui')
  couple.people << Person.find_by_name('Mizuki Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Tereza Simonaka').id, person2_id: Person.find_by_name('Masao Simonaka').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Kuwa Hashimoto').id, person2_id: Person.find_by_name('Nobukichi Usui').id)
  couple.people << Person.find_by_name('Shinajirou Usui')
  couple = Couple.create!(person1_id: Person.find_by_name('Ken Otake').id, person2_id: Person.find_by_name('Yoshitaro Konno').id)
  couple.people << Person.find_by_name('Masako Konno')
  couple.people << Person.find_by_name('Sayoko Konno')
  couple.people << Person.find_by_name('Tomiko Konno')
  couple.people << Person.find_by_name('Rieki Konno')
  couple.people << Person.find_by_name('Jiroh Konno')
  couple.people << Person.find_by_name('Naoshi Konno')
  couple = Couple.create!(person1_id: Person.find_by_name('Masako Konno').id, person2_id: Person.find_by_name('Keizo Satoh').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sayoko Konno').id, person2_id: Person.find_by_name('Zenjiroh Irokawa').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Rieki Konno').id, person2_id: Person.find_by_name('Yukiko Ohgi').id)
  couple.people << Person.find_by_name('Yoshinori Konno')
  couple.people << Person.find_by_name('Toshiko Konno')
  couple = Couple.create!(person1_id: Person.find_by_name('Yoshinori Konno').id, person2_id: Person.find_by_name('Takako Satoh').id)
  couple.people << Person.find_by_name('Sinya Kanno')
  couple.people << Person.find_by_name('Eri Konno')
  couple = Couple.create!(person1_id: Person.find_by_name('Toshiko Konno').id, person2_id: Person.find_by_name('Tamotsu Kojima').id)
  couple.people << Person.find_by_name('Yuhto Kojima')
  couple = Couple.create!(person1_id: Person.find_by_name('Cristina Emi Nakaji').id, person2_id: Person.find_by_name('Hermenegildo Gonçalo da Silva').id, marriage: '2006-7-15')
  couple = Couple.create!(person1_id: Person.find_by_name('Alice Tieco Todaki').id, person2_id: Person.find_by_name('Aroldo Yukio Todaki').id, marriage: '1989-2-18')
  couple.people << Person.find_by_name('Anderson Masao Todaki')
  couple.people << Person.find_by_name('Alessandra Yukari Todaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Tomoyo Job').id, person2_id: Person.find_by_name('Elza Yoshico Job').id)
  couple.people << Person.find_by_name('Lilian Hiromi Job')
  couple.people << Person.find_by_name('Alice Tieco Todaki')
  couple.people << Person.find_by_name('Kiyoshi Job')
  couple = Couple.create!(person1_id: Person.find_by_name('Shizuma Job').id, person2_id: Person.find_by_name('Rumo Job').id)
  couple.people << Person.find_by_name('Tomoyo Job')
  couple.people << Person.find_by_name('Kiyoko Nagatomo')
  couple.people << Person.find_by_name('Yoshinobu Jyo')
  couple.people << Person.find_by_name('Mario Jyo')
  couple.people << Person.find_by_name('Yumio Jyo')
  couple.people << Person.find_by_name('Hiro Saito')
  couple.people << Person.find_by_name('Nobuo Jyo')
  couple.people << Person.find_by_name('Norisato Jyo')
  couple.people << Person.find_by_name('Sachiko Jyo Mikado')
  couple.people << Person.find_by_name('Shizuori Jyo')
  couple.people << Person.find_by_name('Yuiko Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Minoru Miura').id, person2_id: Person.find_by_name('Yuriko Miura').id)
  couple.people << Person.find_by_name('Jorge Miura')
  couple = Couple.create!(person1_id: Person.find_by_name('Hiroyuki Todaki').id, person2_id: Person.find_by_name('Sadako Todaki').id)
  couple.people << Person.find_by_name('Aroldo Yukio Todaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Chiyo Shinozuka').id, person2_id: Person.find_by_name('Yasunaga Yokoyama').id)
  couple.people << Person.find_by_name('Olga Hiromi Yokoyama')
  couple.people << Person.find_by_name('Walter Hitoshi Yokoyama')
  couple = Couple.create!(person1_id: Person.find_by_name('Tama Shinozuka').id, person2_id: Person.find_by_name('Masakatsu Shinozuka').id)
  couple.people << Person.find_by_name('Elza Yoshico Job')
  couple.people << Person.find_by_name('Masaru Shinozuka')
  couple.people << Person.find_by_name('Maria Marie Yokoyama')
  couple.people << Person.find_by_name('Emilia Emiko Heira')
  couple.people << Person.find_by_name('Luiza Misayo Nagatomo')
  couple.people << Person.find_by_name('Rosa Kikue Hirata')
  couple.people << Person.find_by_name('Masae Eishima')
  couple = Couple.create!(person1_id: Person.find_by_name('Fumie Jyo').id, person2_id: Person.find_by_name('Yoshinobu Jyo').id)
  couple.people << Person.find_by_name('Americo Makoto Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Kiyoko Nagatomo').id, person2_id: Person.find_by_name('Sadami Nagatomo').id)
  couple.people << Person.find_by_name('Masako Nagatomo')
  couple.people << Person.find_by_name('Masahiro Nagatomo')
  couple = Couple.create!(person1_id: Person.find_by_name('Ayako Jyo').id, person2_id: Person.find_by_name('Mario Jyo').id)
  couple.people << Person.find_by_name('Marie Jyo')
  couple.people << Person.find_by_name('Mery Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Yumio Jyo').id, person2_id: Person.find_by_name('Mitsue Jyo').id)
  couple.people << Person.find_by_name('Aparecida Mitiko Matsumura')
  couple = Couple.create!(person1_id: Person.find_by_name('Jorge Matsumura').id, person2_id: Person.find_by_name('Aparecida Mitiko Matsumura').id)
  couple.people << Person.find_by_name('Daniel Matsumura')
  couple.people << Person.find_by_name('Cinthia Jyo Grossi')
  couple = Couple.create!(person1_id: Person.find_by_name('Edgard Grossi').id, person2_id: Person.find_by_name('Cinthia Jyo Grossi').id)
  couple.people << Person.find_by_name('Naomi Grossi Matsumura')
  couple = Couple.create!(person1_id: Person.find_by_name('Daniel Matsumura').id, person2_id: Person.find_by_name('Carolina de Fatima Matsumura').id)
  couple.people << Person.find_by_name('Aline Yumi Cerutte Matsumura')
  couple = Couple.create!(person1_id: Person.find_by_name('Hiro Saito').id, person2_id: Person.find_by_name('Takashi Saito').id)
  couple.people << Person.find_by_name('Seiki Saito')
  couple.people << Person.find_by_name('Kouki Saito')
  couple.people << Person.find_by_name('Kou Saito')
  couple.people << Person.find_by_name('Tamaki Saito')
  couple.people << Person.find_by_name('Foobum Saito')
  couple = Couple.create!(person1_id: Person.find_by_name('Tamaki Saito').id, person2_id: Person.find_by_name('Sadako Saito').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Seiki Saito').id, person2_id: Person.find_by_name('Keiko Saito').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Nobuo Jyo').id, person2_id: Person.find_by_name('Mitsue Jyo').id)
  couple.people << Person.find_by_name('Antonio Coocei Jyo')
  couple.people << Person.find_by_name('Nobuko Hayashihara')
  couple.people << Person.find_by_name('Alice Masami Jyo Rodrigues')
  couple.people << Person.find_by_name('Amélia Makiko Jyo')
  couple.people << Person.find_by_name('Augusto Tacao Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Antonio Coocei Jyo').id, person2_id: Person.find_by_name('Tereza Hatsuko Jyo').id)
  couple.people << Person.find_by_name('Leonardo Mitsuru Jyo')
  couple.people << Person.find_by_name('Lucio Masashigue Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Nobuko Hayashihara').id, person2_id: Person.find_by_name('Ryu Hayashihara').id)
  couple.people << Person.find_by_name('Denis Akira Hayashihara')
  couple.people << Person.find_by_name('Dalton Hideo Hayashihara')
  couple.people << Person.find_by_name('Daniel Hiroshi Hayashihara')
  couple = Couple.create!(person1_id: Person.find_by_name('Denis Akira Hayashihara').id, person2_id: Person.find_by_name('Fernanda').id)
  couple.people << Person.find_by_name('Eduardo Kazuya Hayashihara')
  couple = Couple.create!(person1_id: Person.find_by_name('Denis Akira Hayashihara').id, person2_id: Person.find_by_name('Ângela Hayashihara').id)
  couple.people << Person.find_by_name('Daniel Kazuo Hayashihara')
  couple.people << Person.find_by_name('Isabela Sakura Hayashihara')
  couple.people << Person.find_by_name('Nicolas Daiki Hayashihara')
  couple = Couple.create!(person1_id: Person.find_by_name('Shizuori Jyo').id, person2_id: Person.find_by_name('Toshiko Jyo').id)
  couple.people << Person.find_by_name('Akiko Suzuki')
  couple.people << Person.find_by_name('Kimiko Kuamoto')
  couple.people << Person.find_by_name('Kouki Jyo')
  couple.people << Person.find_by_name('Luis Jyo')
  couple.people << Person.find_by_name('Mieko Jyo Eishima')
  couple.people << Person.find_by_name('Noriaki Jyo')
  couple.people << Person.find_by_name('Paulo Takaaki Jyo')
  couple.people << Person.find_by_name('Yoshie Nagatomo')
  couple.people << Person.find_by_name('Masako Nagatomo')
  couple = Couple.create!(person1_id: Person.find_by_name('Luis Jyo').id, person2_id: Person.find_by_name('Mitiko Jyo').id)
  couple.people << Person.find_by_name('Cristiane Liuko Jyo')
  couple.people << Person.find_by_name('Karen Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Carlos Eugênio Malfatti').id, person2_id: Person.find_by_name('Cristiane Liuko Jyo').id)
  couple.people << Person.find_by_name('Carlos Eugênio Malfatti Júnior')
  couple = Couple.create!(person1_id: Person.find_by_name('Carlos Eugênio Malfatti Júnior').id, person2_id: Person.find_by_name('Juliana de Freitas Malfatti').id)
  couple.people << Person.find_by_name('Alice de Freitas Jyo Malfatti')
  couple = Couple.create!(person1_id: Person.find_by_name('Lauro Eishima').id, person2_id: Person.find_by_name('Mieko Jyo Eishima').id)
  couple.people << Person.find_by_name('Renato Seiji Eishima')
  couple.people << Person.find_by_name('Rubens Haruo Eishima')
  couple.people << Person.find_by_name('Suzana Yassue Eishima')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabio').id, person2_id: Person.find_by_name('Kazumi').id)
  couple.people << Person.find_by_name('Aya')
  couple.people << Person.find_by_name('Takeshi')
  couple = Couple.create!(person1_id: Person.find_by_name('Aya').id, person2_id: Person.find_by_name('Takeshi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Keiji').id, person2_id: Person.find_by_name('Tiemi').id)
  couple.people << Person.find_by_name('Yukio')
  couple.people << Person.find_by_name('Yuzo')
  couple = Couple.create!(person1_id: Person.find_by_name('Adilson Nunes Pereira').id, person2_id: Person.find_by_name('Karen Jyo').id)
  couple.people << Person.find_by_name('Letícia Jyo Pereira')
  couple = Couple.create!(person1_id: Person.find_by_name('Takeshi Nagatomo').id, person2_id: Person.find_by_name('Masako Nagatomo').id)
  couple.people << Person.find_by_name('Akemi')
  couple.people << Person.find_by_name('Kazumi')
  couple.people << Person.find_by_name('Masayuki')
  couple.people << Person.find_by_name('Mitsuaki')
  couple.people << Person.find_by_name('Tiemi')
  couple.people << Person.find_by_name('Yassuo')
  couple = Couple.create!(person1_id: Person.find_by_name('Mitsuaki').id, person2_id: Person.find_by_name('Rose').id)
  couple.people << Person.find_by_name('Jun')
  couple = Couple.create!(person1_id: Person.find_by_name('Akemi').id, person2_id: Person.find_by_name('Masayuki').id)
  couple.people << Person.find_by_name('Aiko')
  couple.people << Person.find_by_name('Rodrigo')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabiana').id, person2_id: Person.find_by_name('Yassuo').id)
  couple.people << Person.find_by_name('Daniel Akira Nagatomo')
  couple.people << Person.find_by_name('Shinji')
  couple = Couple.create!(person1_id: Person.find_by_name('Akemi').id, person2_id: Person.find_by_name('Takashi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Paulo Takaaki Jyo').id, person2_id: Person.find_by_name('Toyoko Takeshita').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Kouki Jyo').id, person2_id: Person.find_by_name('Mizue').id)
  couple.people << Person.find_by_name('Lincoln Koiti Jyo')
  couple.people << Person.find_by_name('Marina Ayumi Jyo')
  couple.people << Person.find_by_name('Roseli Mie Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('João Manabu Kuamoto').id, person2_id: Person.find_by_name('Kimiko Kuamoto').id)
  couple.people << Person.find_by_name('Oswaldo Makoto Kuamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Masanori Nagatomo').id, person2_id: Person.find_by_name('Yoshie Nagatomo').id)
  couple.people << Person.find_by_name('Carol Nagatomo')
  couple.people << Person.find_by_name('Rogerio Nagatomo')
  couple = Couple.create!(person1_id: Person.find_by_name('Carol Nagatomo').id, person2_id: Person.find_by_name('Yutaka Yamaniha').id)
  couple.people << Person.find_by_name('Kenzo Yamaniha')
  couple = Couple.create!(person1_id: Person.find_by_name('Daniella Mello').id, person2_id: Person.find_by_name('Rogerio Nagatomo').id)
  couple.people << Person.find_by_name('Gustavo Nagatomo')
  couple.people << Person.find_by_name('Rafaela Nagatomo')
  couple = Couple.create!(person1_id: Person.find_by_name('Akiko Suzuki').id, person2_id: Person.find_by_name('Katsuki Suzuki').id)
  couple.people << Person.find_by_name('Adriana Miyuki Suzuki')
  couple.people << Person.find_by_name('Mirian Megumi Suzuki')
  couple.people << Person.find_by_name('Newton Hideki Suzuki')
  couple.people << Person.find_by_name('Sandra Sayuri Suzuki')
  couple = Couple.create!(person1_id: Person.find_by_name('Drayton').id, person2_id: Person.find_by_name('Sandra Sayuri Suzuki').id)
  couple.people << Person.find_by_name('Júlia Akemi')
  couple = Couple.create!(person1_id: Person.find_by_name('Leonardo').id, person2_id: Person.find_by_name('Mirian Megumi Suzuki').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Sachiko Jyo Mikado').id, person2_id: Person.find_by_name('Yoshiaki Mikado').id)
  couple.people << Person.find_by_name('Alice Tokiko Mikado')
  couple.people << Person.find_by_name('Hideki Mikado')
  couple.people << Person.find_by_name('Mikio Mikado')
  couple.people << Person.find_by_name('Nelson Masamitsu Mikado')
  couple.people << Person.find_by_name('Paulo Mikado')
  couple.people << Person.find_by_name('Rosa Kazuko Mikado')
  couple.people << Person.find_by_name('Yoshie Takazono')
  couple = Couple.create!(person1_id: Person.find_by_name('Alice Tokiko Mikado').id, person2_id: Person.find_by_name('Elido Augusto Vital').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Eliza Satiyo Motoike').id, person2_id: Person.find_by_name('Paulo Mikado').id)
  couple.people << Person.find_by_name('Fabio Hideki Mikado')
  couple = Couple.create!(person1_id: Person.find_by_name('Eliza Tiemi Takeda').id, person2_id: Person.find_by_name('Mikio Mikado').id)
  couple.people << Person.find_by_name('Priscila Mayumi Seki Mikado')
  couple.people << Person.find_by_name('Ricardo Seki Mikado')
  couple = Couple.create!(person1_id: Person.find_by_name('Paulo Eduardo Maia Lourenço').id, person2_id: Person.find_by_name('Priscila Mayumi Seki Mikado').id)
  couple.people << Person.find_by_name('Yasmin Tiemi Mikado Lourenço')
  couple = Couple.create!(person1_id: Person.find_by_name('Ana de Oliveira Neto Mikado').id, person2_id: Person.find_by_name('Nelson Masamitsu Mikado').id)
  couple.people << Person.find_by_name('Thiago Masao Mikado')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Mikado').id, person2_id: Person.find_by_name('Thiago Masao Mikado').id)
  couple.people << Person.find_by_name('Karina Tieko Mikado')
  couple = Couple.create!(person1_id: Person.find_by_name('Karina Tieko Mikado').id, person2_id: Person.find_by_name('Ricardo').id)
  couple.people << Person.find_by_name('Yasmim Sayuri')
  couple = Couple.create!(person1_id: Person.find_by_name('Rosa Kazuko Mikado').id, person2_id: Person.find_by_name('Satoshi Fukushima').id)
  couple.people << Person.find_by_name('Alexandre Fukushima')
  couple.people << Person.find_by_name('Ronaldo Fukushima')
  couple = Couple.create!(person1_id: Person.find_by_name('Luci').id, person2_id: Person.find_by_name('Ronaldo Fukushima').id)
  couple.people << Person.find_by_name('Lua Fukushima')
  couple.people << Person.find_by_name('Mana Fukushima')
  couple = Couple.create!(person1_id: Person.find_by_name('Alexandre Fukushima').id, person2_id: Person.find_by_name('Marli Fukushima').id)
  couple.people << Person.find_by_name('Victor Fukushima')
  couple = Couple.create!(person1_id: Person.find_by_name('Antonio Hajime Takazono').id, person2_id: Person.find_by_name('Yoshie Takazono').id)
  couple.people << Person.find_by_name('Rogério Radyme Takazono')
  couple.people << Person.find_by_name('Rosangela Eiko Takazono')
  couple = Couple.create!(person1_id: Person.find_by_name('Lucimeire Suzuki').id, person2_id: Person.find_by_name('Rogério Radyme Takazono').id)
  couple.people << Person.find_by_name('Guilherme Erick Seiji Takazono')
  couple.people << Person.find_by_name('Marianna Emy Takazono')
  couple.people << Person.find_by_name('Rodrigo Hajime Takazono')
  couple = Couple.create!(person1_id: Person.find_by_name('Luiz').id, person2_id: Person.find_by_name('Marianna Emy Takazono').id)
  couple.people << Person.find_by_name('Giovanna Ayumi da Silva')
  couple = Couple.create!(person1_id: Person.find_by_name('Gerson Koichi Miike').id, person2_id: Person.find_by_name('Rosangela Eiko Takazono').id)
  couple.people << Person.find_by_name('Melissa Miike')
  couple = Couple.create!(person1_id: Person.find_by_name('Norisato Jyo').id, person2_id: Person.find_by_name('Yoshiko Jyo').id)
  couple.people << Person.find_by_name('Antonio Masahiro Jyo')
  couple.people << Person.find_by_name('Katsushi Jyo')
  couple.people << Person.find_by_name('Mizue Jyo')
  couple.people << Person.find_by_name('Nelson Masanori Jyo')
  couple.people << Person.find_by_name('Teruko Jyo Matsuda')
  couple = Couple.create!(person1_id: Person.find_by_name('Koiti Matsuda').id, person2_id: Person.find_by_name('Teruko Jyo Matsuda').id)
  couple.people << Person.find_by_name('Adriana Mitsue Matsuda')
  couple.people << Person.find_by_name('Eduardo Hideki Matsuda')
  couple.people << Person.find_by_name('Mariana Tiemi Matsuda')
  couple = Couple.create!(person1_id: Person.find_by_name('Nelson Masanori Jyo').id, person2_id: Person.find_by_name('Rachel Moraes').id)
  couple.people << Person.find_by_name('Rafael Yukio Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Cintia Biáforo Jyo').id, person2_id: Person.find_by_name('Rafael Yukio Jyo').id)
  couple.people << Person.find_by_name('Julia Mei Biaforo Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Antonio Masahiro Jyo').id, person2_id: Person.find_by_name('Márcia Monaco').id)
  couple.people << Person.find_by_name('Marcella Monaco Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Katsushi Jyo').id, person2_id: Person.find_by_name('Marcia M. Okumura Jyo').id)
  couple.people << Person.find_by_name('Eric Eiji Jyo')
  couple.people << Person.find_by_name('Natália Yurie Jyo')
  couple.people << Person.find_by_name('Theo Seiji Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Mizue Jyo').id, person2_id: Person.find_by_name('Sergio Bernardy').id)
  couple.people << Person.find_by_name('Yudi Gunter Jyo Bernardy')
  couple = Couple.create!(person1_id: Person.find_by_name('Takefumi Kaneko').id, person2_id: Person.find_by_name('Yuiko Kaneko').id)
  couple.people << Person.find_by_name('Alice Takako Kaneko Abe')
  couple.people << Person.find_by_name('Cecília Mieko Kaneko')
  couple.people << Person.find_by_name('Dirce Kazuko Kaneko')
  couple.people << Person.find_by_name('Elisa Suemi Kaneko')
  couple.people << Person.find_by_name('José Masayuki Kaneko')
  couple.people << Person.find_by_name('Luiza Naoko Teramoto')
  couple.people << Person.find_by_name('Neusa Hetsuko Kaneko Ueno')
  couple.people << Person.find_by_name('Oscar Kiyomi Kaneko')
  couple.people << Person.find_by_name('Paulo Akio Kaneko')
  couple.people << Person.find_by_name('Tadashi Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Elisa Suemi Kaneko').id, person2_id: Person.find_by_name('Jorge Tagami').id)
  couple.people << Person.find_by_name('Carolina Marie Tagami')
  couple.people << Person.find_by_name('Vanessa Mieko Tagami')
  couple = Couple.create!(person1_id: Person.find_by_name('Dirce Kazuko Kaneko').id, person2_id: Person.find_by_name('Valentino Nishina').id)
  couple.people << Person.find_by_name('Dylan Nishina')
  couple = Couple.create!(person1_id: Person.find_by_name('Cecília Mieko Kaneko').id, person2_id: Person.find_by_name('Milton Hiroshi Matsuno').id)
  couple.people << Person.find_by_name('Victor Kaneko Matsuno')
  couple = Couple.create!(person1_id: Person.find_by_name('Carlos Joji Ueno').id, person2_id: Person.find_by_name('Neusa Hetsuko Kaneko Ueno').id)
  couple.people << Person.find_by_name('Daniel Hideki Ueno')
  couple.people << Person.find_by_name('Juliana Akemi Ueno')
  couple.people << Person.find_by_name('Marcel Yuji Ueno')
  couple = Couple.create!(person1_id: Person.find_by_name('Eby Hisayo Kaneko').id, person2_id: Person.find_by_name('Oscar Kiyomi Kaneko').id)
  couple.people << Person.find_by_name('Aline Kaneko')
  couple.people << Person.find_by_name('Érika Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Alice Takako Kaneko Abe').id, person2_id: Person.find_by_name('Linton Hiroki Abe').id)
  couple.people << Person.find_by_name('Camila Hiromi Abe')
  couple.people << Person.find_by_name('Ricardo Makoto Abe')
  couple = Couple.create!(person1_id: Person.find_by_name('Ricardo Makoto Abe').id, person2_id: Person.find_by_name('Sandra dos Santos Alencar').id)
  couple.people << Person.find_by_name('Sophia Sayuri Abe')
  couple = Couple.create!(person1_id: Person.find_by_name('Adriana Hitomi Morinaga').id, person2_id: Person.find_by_name('Ricardo Makoto Abe').id)
  couple.people << Person.find_by_name('Jhonny Makoto Abe')
  couple.people << Person.find_by_name('Mariane Yumi Abe')
  couple = Couple.create!(person1_id: Person.find_by_name('Alexandro Simabuco').id, person2_id: Person.find_by_name('Camila Hiromi Abe').id)
  couple.people << Person.find_by_name('Gustavo Hideaki Simabuco')
  couple = Couple.create!(person1_id: Person.find_by_name('José Masayuki Kaneko').id, person2_id: Person.find_by_name('Rosa Kimie Kaneko').id)
  couple.people << Person.find_by_name('Lilian Mayumi Nishida')
  couple.people << Person.find_by_name('Marcelo Takeshi Kaneko')
  couple.people << Person.find_by_name('Marcos Kenji Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Lilian Mayumi Nishida').id, person2_id: Person.find_by_name('Marcio Hideki Nishida').id)
  couple.people << Person.find_by_name('Eduardo Seiji Nishida')
  couple.people << Person.find_by_name('Julio Nishida')
  couple = Couple.create!(person1_id: Person.find_by_name('Jorge Yuzuru Teramoto').id, person2_id: Person.find_by_name('Luiza Naoko Teramoto').id)
  couple.people << Person.find_by_name('Alexandra Miyuki Teramoto')
  couple.people << Person.find_by_name('Rafael Seiki Teramoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Helena Midori Kaneko').id, person2_id: Person.find_by_name('Paulo Akio Kaneko').id)
  couple.people << Person.find_by_name('Márcio Eiiti Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Márcio Eiiti Kaneko').id, person2_id: Person.find_by_name('Selma Kaneko').id)
  couple.people << Person.find_by_name('Fábio Akira Kaneko')
  couple.people << Person.find_by_name('Fernando Takashi Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Nobuko Kaneko').id, person2_id: Person.find_by_name('Tadashi Kaneko').id)
  couple.people << Person.find_by_name('Renato Satio Kaneko')
  couple = Couple.create!(person1_id: Person.find_by_name('Alice Masami Jyo Rodrigues').id, person2_id: Person.find_by_name('Rubens de Oliveira Rodrigues').id)
  couple.people << Person.find_by_name('Gabriela Yumi Rodrigues')
  couple.people << Person.find_by_name('Thiago Tetsuya Rodrigues')
  couple = Couple.create!(person1_id: Person.find_by_name('Augusto Tacao Jyo').id, person2_id: Person.find_by_name('Elizabeth Miyagusuku').id)
  couple.people << Person.find_by_name('Caio Tetsuo Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('João Fernandes').id, person2_id: Person.find_by_name('Madalena Fernandes Mello').id)
  couple.people << Person.find_by_name('Lucia Fernandes Mello Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Katsujiro Omi').id, person2_id: Person.find_by_name('Ei Omi').id)
  couple.people << Person.find_by_name('Yaso Omi')
  couple.people << Person.find_by_name('Antonio Masarmi Omi')
  couple = Couple.create!(person1_id: Person.find_by_name('Fernando de Brito').id, person2_id: Person.find_by_name('Julieta de Luna Brito').id)
  couple.people << Person.find_by_name('Silvia Aparecida de Brito Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Ivino Carneiro da Silva').id, person2_id: Person.find_by_name('Quitéria Basílio da Silva').id)
  couple.people << Person.find_by_name('Luzinete Carneiro da Silva Otake')
  couple.people << Person.find_by_name('Lucia Maria Carneiro')
  couple = Couple.create!(person1_id: Person.find_by_name('Kusuichi Nakao').id, person2_id: Person.find_by_name('Haguine Nakao').id)
  couple.people << Person.find_by_name('Hetsuko Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Yoshio Otake').id, person2_id: Person.find_by_name('Sem cadastro Matsubara').id)
  couple.people << Person.find_by_name('Kazue Matsubara')
  couple.people << Person.find_by_name('Tomiko Matsubara')
  couple.people << Person.find_by_name('Masahiro Isaka')
  couple = Couple.create!(person1_id: Person.find_by_name('Eduardo Mitio Ueno').id, person2_id: Person.find_by_name('Cintia Yumi Nakagawa').id)
  couple.people << Person.find_by_name('Roberto Hideki Ueno')
  couple = Couple.create!(person1_id: Person.find_by_name('Rodrigo Eiji Sakamoto').id, person2_id: Person.find_by_name('Kelly Simões de Lima').id)
  couple.people << Person.find_by_name('Leonardo Kenji Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Cristina Sayuri Ueno').id, person2_id: Person.find_by_name('Igor Osawa').id)
  couple.people << Person.find_by_name('Leonardo Masao Osawa')
  couple.people << Person.find_by_name('Luciana Mei Osawa')
  couple.people << Person.find_by_name('Melissa Ayumi Osawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Juliana Sakamoto Omi').id, person2_id: Person.find_by_name('Ravel Michellom Kirschke Fagundes').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Thiago Tomio Sakamoto').id, person2_id: Person.find_by_name('Lais Fregonezi').id)
  couple.people << Person.find_by_name('Gabriel Fregonezi Sakamoto')
  couple.people << Person.find_by_name('Júlia Fregonezi Sakamoto')
  couple.people << Person.find_by_name('Melissa Fregonezi Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Armando Massao Sakamoto').id, person2_id: Person.find_by_name('Teresa').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Mariana Mieko Sakamoto').id, person2_id: Person.find_by_name('Pedro Fabiano de Morais Sarmento').id)
  couple.people << Person.find_by_name('Felipe Sakamoto Sarmento')
  couple.people << Person.find_by_name('Lila Sakamoto Sarmento')
  couple = Couple.create!(person1_id: Person.find_by_name('Daniel Hideki Sakamoto').id, person2_id: Person.find_by_name('Carol Lacerda').id)
  couple.people << Person.find_by_name('Noah Kai Lacerda Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Helena Tanaka').id, person2_id: Person.find_by_name('Sem cadastro Helena Tanaka').id)
  couple.people << Person.find_by_name('Marisa')
  couple.people << Person.find_by_name('Gabriela')
  couple = Couple.create!(person1_id: Person.find_by_name('Masaru Shinozuka').id, person2_id: Person.find_by_name('Tiyoko Shinozuka').id)
  couple.people << Person.find_by_name('Yoshiaki Shinozuka')
  couple.people << Person.find_by_name('Yassuo Shinozuka')
  couple.people << Person.find_by_name('Masanobu Shinozuka')
  couple.people << Person.find_by_name('Harumi Shinozuka')
  couple = Couple.create!(person1_id: Person.find_by_name('Maria Marie Yokoyama').id, person2_id: Person.find_by_name('Yutaka Yokoyama').id)
  couple.people << Person.find_by_name('Miyuki Yokoyama')
  couple = Couple.create!(person1_id: Person.find_by_name('Emilia Emiko Heira').id, person2_id: Person.find_by_name('Masanori Heira').id, marriage: '1967-11-21', local: 'Butantã/SP')
  couple.people << Person.find_by_name('Francisco Koretika Heira')
  couple.people << Person.find_by_name('Marta Yoshiko Heira')
  couple = Couple.create!(person1_id: Person.find_by_name('Luiza Misayo Nagatomo').id, person2_id: Person.find_by_name('Terumitsu Nagatomo').id)
  couple.people << Person.find_by_name('Roberto Kiyotaka Nagatomo')
  couple.people << Person.find_by_name('Nicia Toshiko Nagatomo')
  couple = Couple.create!(person1_id: Person.find_by_name('Rosa Kikue Hirata').id, person2_id: Person.find_by_name('Carlos Akio Hirata').id)
  couple.people << Person.find_by_name('Claudio Mitio Hirata')
  couple.people << Person.find_by_name('Regina Kiyomi Hirata Kamogawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Masae Eishima').id, person2_id: Person.find_by_name('Milton Eishima').id)
  couple.people << Person.find_by_name('Erica Harumi Eishima Tanabe')
  couple.people << Person.find_by_name('Emilia Emiko Eishima')
  couple.people << Person.find_by_name('Mari Eishima Chikasawa')
  couple.people << Person.find_by_name('Regina Yoko Eishima')
  couple = Couple.create!(person1_id: Person.find_by_name('Rimpei Shinozuka').id, person2_id: Person.find_by_name('Toku Shinozuka').id)
  couple.people << Person.find_by_name('Chiyo Shinozuka')
  couple.people << Person.find_by_name('Sukehei Shinozuka')
  couple.people << Person.find_by_name('Teinosuke Shinozuka')
  couple.people << Person.find_by_name('Seizo Shinozuka')
  couple.people << Person.find_by_name('Miyoko Shinozuka')
  couple.people << Person.find_by_name('Shinobu Shinozuka')
  couple.people << Person.find_by_name('Keiya Shinozuka')
  couple.people << Person.find_by_name('Kaoru Shinozuka')
  couple.people << Person.find_by_name('Kiyoko Shinozuka')
  couple.people << Person.find_by_name('Tama Shinozuka')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Eishima').id, person2_id: Person.find_by_name('Toshiko Eishima').id)
  couple.people << Person.find_by_name('Lauro Eishima')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Matsuda').id, person2_id: Person.find_by_name('Emiko Matsuda').id)
  couple.people << Person.find_by_name('Koiti Matsuda')
  couple = Couple.create!(person1_id: Person.find_by_name('Kyoji Matsuda').id, person2_id: Person.find_by_name('Mitsuko Matsuda').id)
  couple.people << Person.find_by_name('Fumiko Tanaka')
  couple.people << Person.find_by_name('Takio Matsuda')
  couple.people << Person.find_by_name('Toshiko Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Fusako Takeshita').id, person2_id: Person.find_by_name('Tsuneto Takeshita').id)
  couple.people << Person.find_by_name('Toyoko Takeshita')
  couple = Couple.create!(person1_id: Person.find_by_name('Alexandre Fukushima').id, person2_id: Person.find_by_name('Heloisa Fukushima').id)
  couple = Couple.create!(person1_id: Person.find_by_name('José Mikado').id, person2_id: Person.find_by_name('Kazue Mikado').id)
  couple.people << Person.find_by_name('Mitsue Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Matao Matsumura').id, person2_id: Person.find_by_name('Mioji Matsumura').id)
  couple.people << Person.find_by_name('Jorge Matsumura')
  couple = Couple.create!(person1_id: Person.find_by_name('Mombe Wakamori').id, person2_id: Person.find_by_name('Tamae Wakamori').id)
  couple.people << Person.find_by_name('Yoshiko Jyo')
  couple = Couple.create!(person1_id: Person.find_by_name('Roberta Maria Sakamoto Thomazelli').id, person2_id: Person.find_by_name('Sem cadastro Thomazelli').id)
  couple.people << Person.find_by_name('Mariana Sakamoto')
  couple.people << Person.find_by_name('Kenzo Sakamoto Tomazelli')
  couple = Couple.create!(person1_id: Person.find_by_name('Alessandra Yukari Todaki').id, person2_id: Person.find_by_name('Toshiya Yamada').id, marriage: '2019-12-14')
  couple.people << Person.find_by_name('Sayaka Yamada')
  couple.people << Person.find_by_name('Shiyuki Yamada')
  couple = Couple.create!(person1_id: Person.find_by_name('Erica Harumi Eishima Tanabe').id, person2_id: Person.find_by_name('Guto Tanabe').id)
  couple.people << Person.find_by_name('Leo Tanabe')
  couple = Couple.create!(person1_id: Person.find_by_name('Mari Eishima Chikasawa').id, person2_id: Person.find_by_name('Robson Chikasawa').id)
  couple.people << Person.find_by_name('Melissa Chikazawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Cristina Akemi Otake').id, person2_id: Person.find_by_name('Joelcio Almeida').id)
  couple.people << Person.find_by_name('João Otake Almeida')
  couple = Couple.create!(person1_id: Person.find_by_name('Andre Akiyoshi Miyahara Jr.').id, person2_id: Person.find_by_name('Tihiro Miyahara').id)
  couple.people << Person.find_by_name('Aki Miyahara')
  couple.people << Person.find_by_name('Yuzu Miyahara')
  couple = Couple.create!(person1_id: Person.find_by_name('Suzana Yassue Eishima').id, person2_id: Person.find_by_name('Anderson Soucha').id)
  couple.people << Person.find_by_name('Rodrigo Akira')
  couple = Couple.create!(person1_id: Person.find_by_name('Mayumi Tais Otake').id, person2_id: Person.find_by_name('Milton Kogushi').id)
  couple.people << Person.find_by_name('Iris Souza Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsuya Nakasawa').id, person2_id: Person.find_by_name('Ino Nakasawa').id)
  couple.people << Person.find_by_name('Yatsue Yonekubo')
  couple = Couple.create!(person1_id: Person.find_by_name('Sakutaro Nakaji').id, person2_id: Person.find_by_name('Kiku Nakaji').id)
  couple.people << Person.find_by_name('Sanzan Nakaji')
  couple = Couple.create!(person1_id: Person.find_by_name('Tokogo Ueno').id, person2_id: Person.find_by_name('Mitie Ueno').id)
  couple.people << Person.find_by_name('Keisso Ueno')
  couple = Couple.create!(person1_id: Person.find_by_name('Masakatsu Shinozuka').id, person2_id: Person.find_by_name('Fumie Ishimoto').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Otsuru Yamamoto').id, person2_id: Person.find_by_name('Sem cadastro Yamamoto').id)
  couple.people << Person.find_by_name('Fumie Ishimoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Tatsuji Uemoto').id, person2_id: Person.find_by_name('Tamayo Uemoto').id)
  couple.people << Person.find_by_name('Flora Uemoto Yonekubo')
  couple.people << Person.find_by_name('Sumio Uemoto')
  couple.people << Person.find_by_name('Sumito Uemoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Jishiro Uemoto').id, person2_id: Person.find_by_name('Haruno Uemoto').id)
  couple.people << Person.find_by_name('Tatsuji Uemoto')
  couple.people << Person.find_by_name('Eiichi Uemoto')
  couple.people << Person.find_by_name('Matsuyo Uemoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Saichi Ishimoto').id, person2_id: Person.find_by_name('Ushi Ishimoto').id)
  couple.people << Person.find_by_name('Masakatsu Shinozuka')
  couple = Couple.create!(person1_id: Person.find_by_name('Naozane Heira').id, person2_id: Person.find_by_name('Michi Heira').id)
  couple.people << Person.find_by_name('Masanori Heira')
  couple.people << Person.find_by_name('Yasuko Heira')
  couple.people << Person.find_by_name('Kyoko Okawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Sakuhide So').id, person2_id: Person.find_by_name('Tsuru So').id)
  couple.people << Person.find_by_name('Michi Heira')
  couple.people << Person.find_by_name('Tae Takemiya')
  couple.people << Person.find_by_name('Nobu Nishimura')
  couple = Couple.create!(person1_id: Person.find_by_name('Tae Takemiya').id, person2_id: Person.find_by_name('Hideo Takemiya').id)
  couple.people << Person.find_by_name('Korefumi Takemiya')
  couple = Couple.create!(person1_id: Person.find_by_name('Koreaki Takemiya').id, person2_id: Person.find_by_name('Tsuru Takemiya').id)
  couple.people << Person.find_by_name('Hideo Takemiya')
  couple = Couple.create!(person1_id: Person.find_by_name('Eisaku Ninomiya').id, person2_id: Person.find_by_name('Saki Inoue').id)
  couple.people << Person.find_by_name('Ei Omi')
  couple.people << Person.find_by_name('Hideei Ninomiya')
  couple.people << Person.find_by_name('Michiko Ninomiya')
  couple.people << Person.find_by_name('Katsumi Ninomiya')
  couple = Couple.create!(person1_id: Person.find_by_name('Tozo Misu').id, person2_id: Person.find_by_name('Aki Misu').id)
  couple.people << Person.find_by_name('Mikiji Missu')
  couple.people << Person.find_by_name('Tsuna Misu Komatsu')
  couple = Couple.create!(person1_id: Person.find_by_name('Isuke Kariatsumari').id, person2_id: Person.find_by_name('Ichiki Kariatsumari').id)
  couple.people << Person.find_by_name('Sanshiro Kariatsumari')
  couple = Couple.create!(person1_id: Person.find_by_name('Chojiro Matsumoto').id, person2_id: Person.find_by_name('Soe Matsumoto').id)
  couple.people << Person.find_by_name('Waka Kariatsumari')
  couple = Couple.create!(person1_id: Person.find_by_name('Sanshiro Kariatsumari').id, person2_id: Person.find_by_name('Waka Kariatsumari').id)
  couple.people << Person.find_by_name('Norioki Kariatsumari')
  couple.people << Person.find_by_name('Masaru Kariatsumari')
  couple.people << Person.find_by_name('Minoru Kariatsumari')
  couple.people << Person.find_by_name('Kayako Matsuhata')
  couple.people << Person.find_by_name('Yoriko Samoto')
  couple.people << Person.find_by_name('Yasuo Kariatsumari')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsuneyoshi Kadota').id, person2_id: Person.find_by_name('Haru Kadota').id)
  couple.people << Person.find_by_name('Shoko Kariatsumari')
  couple = Couple.create!(person1_id: Person.find_by_name('Yasuo Kariatsumari').id, person2_id: Person.find_by_name('Shoko Kariatsumari').id)
  couple.people << Person.find_by_name('Helena Ayako Kariatsumari Otake')
  couple.people << Person.find_by_name('Victorio Masashi Kariatsumari')
  couple.people << Person.find_by_name('Jun Kariatsumari')
  couple.people << Person.find_by_name('Yasuyo Kariatsumari')
  couple = Couple.create!(person1_id: Person.find_by_name('Gensaku Ikeda').id, person2_id: Person.find_by_name('Mon Ikeda').id)
  couple.people << Person.find_by_name('Goro Ikeda')
  couple.people << Person.find_by_name('Soichi Ikeda')
  couple.people << Person.find_by_name('Tomoji Ikeda')
  couple.people << Person.find_by_name('Ushimatsu Ikeda')
  couple.people << Person.find_by_name('Shiro Ikeda')
  couple.people << Person.find_by_name('Koharu Ikeda')
  couple.people << Person.find_by_name('Toyoko Murasawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Seikichi Sekiya').id, person2_id: Person.find_by_name('Ei Sekiya').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Ryu Uemoto').id, person2_id: Person.find_by_name('Sem cadastro Uemoto').id)
  couple.people << Person.find_by_name('Jishiro Uemoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Soichiro Yamazaki').id, person2_id: Person.find_by_name('Setsu Yamazaki').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Yasushi Omi').id, person2_id: Person.find_by_name('Yuki Omi').id)
  couple.people << Person.find_by_name('Katsujiro Omi')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Inoue 1').id, person2_id: Person.find_by_name('Sem cadastro Inoue 2').id)
  couple.people << Person.find_by_name('Yoshii Inoue')
  couple = Couple.create!(person1_id: Person.find_by_name('Seikichi Sekiya').id, person2_id: Person.find_by_name('Sem cadastro Sekiya').id)
  couple.people << Person.find_by_name('Setsu Yamazaki')
  couple.people << Person.find_by_name('Kiyoshi Sekiya')
  couple.people << Person.find_by_name('Shoji Sekiya')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Tabuti 1').id, person2_id: Person.find_by_name('Sem cadastro Tabuti 2').id)
  couple.people << Person.find_by_name('Francisco Nobuo Tabuti')
  couple.people << Person.find_by_name('Marcos Yutaka Tabuti')
  couple.people << Person.find_by_name('Rogério Yukio Tabuti')
  couple = Couple.create!(person1_id: Person.find_by_name('Rogério Yukio Tabuti').id, person2_id: Person.find_by_name('Márcia Mie Sericaku Tabuti').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Riichi Akiyoshi').id, person2_id: Person.find_by_name('Yone Akiyoshi').id)
  couple.people << Person.find_by_name('Shikato Akiyoshi')
  couple.people << Person.find_by_name('Hiromi Akiyoshi')
  couple.people << Person.find_by_name('Midori Fujiwara')
  couple.people << Person.find_by_name('Kaoru Akiyoshi')
  couple.people << Person.find_by_name('Mitsuka Akiyoshi')
  couple.people << Person.find_by_name('Hatsumi Akiyoshi')
  couple.people << Person.find_by_name('Iwao Akiyoshi')
  couple.people << Person.find_by_name('Yoshiro Akiyoshi')
  couple.people << Person.find_by_name('Shigeo Akiyoshi')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsunahiko Shimada').id, person2_id: Person.find_by_name('Matsu Shimada').id)
  couple.people << Person.find_by_name('Yasuo Shimada')
  couple.people << Person.find_by_name('Kaneo Shimada')
  couple.people << Person.find_by_name('Fusao Shimada')
  couple.people << Person.find_by_name('Fumi Shimada')
  couple.people << Person.find_by_name('Soe Aoki')
  couple.people << Person.find_by_name('Tsuruko Goto')
  couple.people << Person.find_by_name('Kuni Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsuruko Goto').id, person2_id: Person.find_by_name('Yutaka Goto').id, marriage: '1958-3-29')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Shimada 1').id, person2_id: Person.find_by_name('Sem cadastro Shimada 2').id)
  couple.people << Person.find_by_name('Matsu Shimada')
  couple.people << Person.find_by_name('Minoru Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Hamazo Shimada').id, person2_id: Person.find_by_name('Etsu Shimada').id)
  couple.people << Person.find_by_name('Tsunahiko Shimada')
  couple = Couple.create!(person1_id: Person.find_by_name('Caroline Ranzoni').id, person2_id: Person.find_by_name('Evandro Pereira de Mattos').id)
  couple.people << Person.find_by_name('Evandro Ranzoni Mattos')
  couple = Couple.create!(person1_id: Person.find_by_name('Yosohachi Yokoyama').id, person2_id: Person.find_by_name('Koto Yokoyama').id)
  couple.people << Person.find_by_name('Tsukumo Yokoyama')
  couple.people << Person.find_by_name('Momohachi Yokoyama')
  couple.people << Person.find_by_name('Mihachiro Yokoyama')
  couple.people << Person.find_by_name('Denji Yokoyama')
  couple.people << Person.find_by_name('Momojiro Yokoyama')
  couple.people << Person.find_by_name('Masano Yokoyama')
  couple.people << Person.find_by_name('Satono Yokoyama Muramatsu')
  couple.people << Person.find_by_name('Toyome Satake')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsukumo Yokoyama').id, person2_id: Person.find_by_name('Tsune Yokoyama').id)
  couple.people << Person.find_by_name('Antonio Yokoyama')
  couple = Couple.create!(person1_id: Person.find_by_name('Tsunematsu Ogaki').id, person2_id: Person.find_by_name('Naka Ogaki').id)
  couple.people << Person.find_by_name('Tsune Yokoyama')
  couple.people << Person.find_by_name('Mitsuru Ogaki')
  couple.people << Person.find_by_name('Minoru Ogaki')
  couple.people << Person.find_by_name('Kie Ogaki Tongu')
  couple = Couple.create!(person1_id: Person.find_by_name('Mitsuru Ogaki').id, person2_id: Person.find_by_name('Yuki Ogaki').id, marriage: '1947-2-8', local: 'Uraí/PR')
  couple = Couple.create!(person1_id: Person.find_by_name('Minosuke Morota').id, person2_id: Person.find_by_name('Chiyo Morota').id)
  couple.people << Person.find_by_name('Yuki Ogaki')
  couple.people << Person.find_by_name('Kiyoshi Morota')
  couple = Couple.create!(person1_id: Person.find_by_name('Hidekichi Suwa').id, person2_id: Person.find_by_name('Hiro Suwa').id)
  couple.people << Person.find_by_name('Tsuguo Suwa')
  couple.people << Person.find_by_name('Noboru Suwa')
  couple.people << Person.find_by_name('Hisako Suwa')
  couple.people << Person.find_by_name('Eiko Suwa Morota')
  couple = Couple.create!(person1_id: Person.find_by_name('Jitaro Suwa').id, person2_id: Person.find_by_name('Chika Suwa').id, marriage: '1880-1-1', local: 'Aichi. Dia e mes desconhecidos')
  couple.people << Person.find_by_name('Hidekichi Suwa')
  couple = Couple.create!(person1_id: Person.find_by_name('Yodaemon Matsuda').id, person2_id: Person.find_by_name('Sato Matsuda').id)
  couple.people << Person.find_by_name('Hiro Suwa')
  couple = Couple.create!(person1_id: Person.find_by_name('Hiro Suwa').id, person2_id: Person.find_by_name('Senmatsu Honda').id)
  couple.people << Person.find_by_name('Bunji Honda')
  couple.people << Person.find_by_name('Fumihiko Honda')
  couple = Couple.create!(person1_id: Person.find_by_name('Kiyoshi Morota').id, person2_id: Person.find_by_name('Eiko Suwa Morota').id, marriage: '1949-2-12', local: 'Uraí/PR')
  couple = Couple.create!(person1_id: Person.find_by_name('Fumihiko Honda').id, person2_id: Person.find_by_name('Hana Suzuki Honda').id)
  couple.people << Person.find_by_name('Paulo Miquio Honda')
  couple = Couple.create!(person1_id: Person.find_by_name('Sogoro Suzuki').id, person2_id: Person.find_by_name('Tamano Suzuki').id)
  couple.people << Person.find_by_name('Hana Suzuki Honda')
  couple.people << Person.find_by_name('Chukichi Suzuki')
  couple.people << Person.find_by_name('Sokichi Suzuki')
  couple.people << Person.find_by_name('Hama Suzuki Taira')
  couple.people << Person.find_by_name('Kuni Suzuki')
  couple = Couple.create!(person1_id: Person.find_by_name('Nisoji Takahashi').id, person2_id: Person.find_by_name('Saki Takahashi').id)
  couple.people << Person.find_by_name('Sogoro Suzuki')
  couple = Couple.create!(person1_id: Person.find_by_name('Jyroemon Morota').id, person2_id: Person.find_by_name('Yae Morota').id)
  couple.people << Person.find_by_name('Minosuke Morota')
  couple = Couple.create!(person1_id: Person.find_by_name('Kenda Hirata').id, person2_id: Person.find_by_name('Hatsuko Hirata').id)
  couple.people << Person.find_by_name('Luiza Emiko Hirata')
  couple.people << Person.find_by_name('Carlos Akio Hirata')
  couple = Couple.create!(person1_id: Person.find_by_name('Kentaro Hirata').id, person2_id: Person.find_by_name('Kin Hirata').id)
  couple.people << Person.find_by_name('Kenda Hirata')
  couple = Couple.create!(person1_id: Person.find_by_name('Eitaro Inatomi').id, person2_id: Person.find_by_name('Muneyo Inatomi').id)
  couple.people << Person.find_by_name('Hatsuko Hirata')
  couple.people << Person.find_by_name('Kiyota Inatomi')
  couple.people << Person.find_by_name('Rikita Inatomi')
  couple.people << Person.find_by_name('Masato Inatomi')
  couple.people << Person.find_by_name('Tsuyoshi Inatomi')
  couple.people << Person.find_by_name('Takeo Inatomi')
  couple = Couple.create!(person1_id: Person.find_by_name('Kiri Inatomi').id, person2_id: Person.find_by_name('Katsutaro Inatomi').id)
  couple.people << Person.find_by_name('Eitaro Inatomi')
  couple = Couple.create!(person1_id: Person.find_by_name('Masato Inatomi').id, person2_id: Person.find_by_name('Masako Inatomi').id)
  couple.people << Person.find_by_name('Luiz Shigueo Inatomi')
  couple = Couple.create!(person1_id: Person.find_by_name('Rikita Inatomi').id, person2_id: Person.find_by_name('Fujiko Inatomi').id)
  couple.people << Person.find_by_name('José Yokio Inatomi')
  couple = Couple.create!(person1_id: Person.find_by_name('Masataro Naito').id, person2_id: Person.find_by_name('Shitsu Naito').id, marriage: '1890-1-1', local: 'Fukuoka. Dia e mes desconhecidos')
  couple = Couple.create!(person1_id: Person.find_by_name('Luiz Shigueo Inatomi').id, person2_id: Person.find_by_name('Ana Lucia Chaves').id)
  couple.people << Person.find_by_name('Felipe')
  couple = Couple.create!(person1_id: Person.find_by_name('Kiyota Inatomi').id, person2_id: Person.find_by_name('Teru Inatomi').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Katsuzo Magori').id, person2_id: Person.find_by_name('Tsui Magori').id, marriage: '1915-1-1', local: 'Saga. Dia e mes desconhecidos')
  couple.people << Person.find_by_name('Teru Inatomi')
  couple.people << Person.find_by_name('Tetsuji Magori')
  couple = Couple.create!(person1_id: Person.find_by_name('Regina Kiyomi Hirata Kamogawa').id, person2_id: Person.find_by_name('Bruno Kamogawa').id)
  couple.people << Person.find_by_name('Guilherme Seiji Kamogawa')
  couple.people << Person.find_by_name('Eduardo Kamogawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Francisco Koretika Heira').id, person2_id: Person.find_by_name('Patrícia Sales Patrício').id)
  couple.people << Person.find_by_name('Norio')
  couple.people << Person.find_by_name('Clara Mayumi Heira')
  couple = Couple.create!(person1_id: Person.find_by_name('Marta Yoshiko Heira').id, person2_id: Person.find_by_name('Sem cadastro Akamine').id)
  couple.people << Person.find_by_name('Rodrigo Akamine')
  couple.people << Person.find_by_name('Gabriela Akamine')
  couple = Couple.create!(person1_id: Person.find_by_name('Nicia Toshiko Nagatomo').id, person2_id: Person.find_by_name('Marcos Ouki').id)
  couple.people << Person.find_by_name('Giovana Eiko Ouki')
  couple = Couple.create!(person1_id: Person.find_by_name('Giovana Eiko Ouki').id, person2_id: Person.find_by_name('Sem cadastro Ouki').id)
  couple.people << Person.find_by_name('Vinicius')
  couple = Couple.create!(person1_id: Person.find_by_name('Miyuki Yokoyama').id, person2_id: Person.find_by_name('Kazuhiko').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Tatiane Cristina Otake').id, person2_id: Person.find_by_name('Alex Ezoe').id, marriage: '2005-1-28')
  couple.people << Person.find_by_name('Andressa')
  couple = Couple.create!(person1_id: Person.find_by_name('Miriam Otake de Oliveira').id, person2_id: Person.find_by_name('Silvio da Silva de Oliveira').id)
  couple.people << Person.find_by_name('Kauane Otake Ribeiro da Silva')
  couple.people << Person.find_by_name('Larissa Bini Garcia Otake')
  couple.people << Person.find_by_name('Gabriella Duarte Ribeiro Silva')
  couple = Couple.create!(person1_id: Person.find_by_name('Jorge Yasunori Nakabayashi').id, person2_id: Person.find_by_name('Maria Miyoko').id)
  couple.people << Person.find_by_name('Eduardo Nakabayashi')
  couple.people << Person.find_by_name('Michela')
  couple.people << Person.find_by_name('Gustavo')
  couple.people << Person.find_by_name('Mônica')
  couple = Couple.create!(person1_id: Person.find_by_name('Eduardo Nakabayashi').id, person2_id: Person.find_by_name('Elaine').id)
  couple.people << Person.find_by_name('Manu')
  couple = Couple.create!(person1_id: Person.find_by_name('Sérgio Koji Sakamoto').id, person2_id: Person.find_by_name('Katia Maeda Kanoski').id)
  couple.people << Person.find_by_name('Amanda')
  couple = Couple.create!(person1_id: Person.find_by_name('Ekizo Nakao').id, person2_id: Person.find_by_name('Tome Nakao').id)
  couple.people << Person.find_by_name('Yasuo Nakao')
  couple.people << Person.find_by_name('Kusuichi Nakao')
  couple.people << Person.find_by_name('Yutaka Nakao')
  couple.people << Person.find_by_name('Akira Nakao')
  couple.people << Person.find_by_name('Harumi Nakao')
  couple.people << Person.find_by_name('Shizue Nakao')
  couple = Couple.create!(person1_id: Person.find_by_name('Seiichi Taguchi').id, person2_id: Person.find_by_name('Hatsu Taguchi').id)
  couple.people << Person.find_by_name('Masayoshi Taguchi')
  couple.people << Person.find_by_name('Tadashi Taguchi')
  couple.people << Person.find_by_name('Mamoru Taguchi')
  couple.people << Person.find_by_name('Tamotsu Taguchi')
  couple.people << Person.find_by_name('Yuriko Nakabayashi')
  couple = Couple.create!(person1_id: Person.find_by_name('Mirian').id, person2_id: Person.find_by_name('Wilson').id)
  couple.people << Person.find_by_name('Tadashi Tanaka')
  couple.people << Person.find_by_name('Fumi Nakabayashi')
  couple.people << Person.find_by_name('Matsuo Tanaka')
  couple.people << Person.find_by_name('Kunio Tanaka')
  couple.people << Person.find_by_name('Teruo Tanaka')
  couple.people << Person.find_by_name('Kasue Tanaka')
  couple.people << Person.find_by_name('Fusa Tanaka')
  couple.people << Person.find_by_name('Isabelly')
  couple = Couple.create!(person1_id: Person.find_by_name('Takataro Matsumoto').id, person2_id: Person.find_by_name('Sime Matsumoto').id)
  couple.people << Person.find_by_name('Haguine Nakao')
  couple = Couple.create!(person1_id: Person.find_by_name('Marie Sakamoto').id, person2_id: Person.find_by_name('José Ilson').id)
  couple.people << Person.find_by_name('Mirian')
  couple.people << Person.find_by_name('Rosemeire')
  couple.people << Person.find_by_name('Eduardo')
  couple = Couple.create!(person1_id: Person.find_by_name('Junji Sakamoto').id, person2_id: Person.find_by_name('Sem cadastro Junji').id)
  couple.people << Person.find_by_name('Daniela Sakamoto')
  couple.people << Person.find_by_name('Lucas Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Hiroko Sakamoto').id, person2_id: Person.find_by_name('Cícero').id)
  couple.people << Person.find_by_name('Luciane Yumi')
  couple.people << Person.find_by_name('Cristiane Mayumi')
  couple = Couple.create!(person1_id: Person.find_by_name('Elina Sakamoto').id, person2_id: Person.find_by_name('Sem cadastro Elina').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Atsuko Yamamoto').id, person2_id: Person.find_by_name('Yuji Yamamoto').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Rosemeire').id, person2_id: Person.find_by_name('Mauro').id)
  couple.people << Person.find_by_name('Camilla')
  couple = Couple.create!(person1_id: Person.find_by_name('Eduardo').id, person2_id: Person.find_by_name('Gislaine').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Ednei').id, person2_id: Person.find_by_name('Luciane Yumi').id)
  couple.people << Person.find_by_name('Rafaela')
  couple = Couple.create!(person1_id: Person.find_by_name('Sem cadastro Mayumi').id, person2_id: Person.find_by_name('Cristiane Mayumi').id)
  couple.people << Person.find_by_name('Breno')
  couple = Couple.create!(person1_id: Person.find_by_name('Chikashi Kondo').id, person2_id: Person.find_by_name('Hatsumi Kondo').id)
  couple.people << Person.find_by_name('Yoko Kondo')
  couple.people << Person.find_by_name('Yoshie Sakamoto')
  couple.people << Person.find_by_name('Sumie Kondo')
  couple.people << Person.find_by_name('Chikae Waragai')
  couple.people << Person.find_by_name('Akira Kondo')
  couple = Couple.create!(person1_id: Person.find_by_name('Mitinoiti Kondo').id, person2_id: Person.find_by_name('Torano Kondo').id)
  couple.people << Person.find_by_name('Chikashi Kondo')
  couple = Couple.create!(person1_id: Person.find_by_name('Tamekichi Ogata').id, person2_id: Person.find_by_name('Kikuno Ogata').id)
  couple.people << Person.find_by_name('Hatsumi Kondo')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabiana da Cruz Otake').id, person2_id: Person.find_by_name('Claudio Teles Filho').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Juliana da Cruz Otake').id, person2_id: Person.find_by_name('Sem cadastro Juliana').id)
  couple.people << Person.find_by_name('Camila Yumi Otake Maki')
  couple.people << Person.find_by_name('Rafaela Thiemi Otake Andrade')
  couple = Couple.create!(person1_id: Person.find_by_name('Felipe da Cruz Otake').id, person2_id: Person.find_by_name('Sem cadastro Felipe').id)
  couple.people << Person.find_by_name('Victor Felipe Nominato Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Felipe da Cruz Otake').id, person2_id: Person.find_by_name('Michaele Francisbel Cunico Otake').id)
  couple.people << Person.find_by_name('Ryan Cunico Otake')
  couple.people << Person.find_by_name('Bryan Cunico Otake')
  couple = Couple.create!(person1_id: Person.find_by_name('Fabio da Cruz Otake').id, person2_id: Person.find_by_name('Arielly da Silva Otake').id)
  couple = Couple.create!(person1_id: Person.find_by_name('Alice Tieco Todaki').id, person2_id: Person.find_by_name('Elio Tadashi Kazihara').id, marriage: '2023-05-22')
  couple = Couple.create!(person1_id: Person.find_by_name('Chikae Waragai').id, person2_id: Person.find_by_name('Tatsugoro Waragai').id, marriage: '1954-1-2')
  couple = Couple.create!(person1_id: Person.find_by_name('Sanju Waragai').id, person2_id: Person.find_by_name('Gin Waragai').id)
  couple.people << Person.find_by_name('Tatsugoro Waragai')
  couple = Couple.create!(person1_id: Person.find_by_name('Masaemon Sekito').id, person2_id: Person.find_by_name('Tome Sekito').id)
  couple.people << Person.find_by_name('Tomi Sekito Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Monjiro Maruo').id, person2_id: Person.find_by_name('Tora Maruo').id)
  couple.people << Person.find_by_name('Teruko Maruo Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Sueichi Fujisawa').id, person2_id: Person.find_by_name('Yukino Fujisawa').id)
  couple.people << Person.find_by_name('Haruko Fujisawa')
  couple = Couple.create!(person1_id: Person.find_by_name('Seyishi Sakamoto').id, person2_id: Person.find_by_name('Lourdes Koroshue Sakamoto').id)
  couple.people << Person.find_by_name('Kátia Lie Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Nobuichi Koroshue').id, person2_id: Person.find_by_name('Asako Sezaki').id)
  couple.people << Person.find_by_name('Lourdes Koroshue Sakamoto')
  couple = Couple.create!(person1_id: Person.find_by_name('Hidetaro Kuraba').id, person2_id: Person.find_by_name('Sigeco Nakashima Kuraba').id)
  couple.people << Person.find_by_name('Ayaka Yamazaki')
  couple = Couple.create!(person1_id: Person.find_by_name('Shigueyoshi Nakamura').id, person2_id: Person.find_by_name('Kiku Nakamura').id)
  couple.people << Person.find_by_name('Mitio Nakamura')
  couple = Couple.create!(person1_id: Person.find_by_name('Emilia Setuko Sakamoto').id, person2_id: Person.find_by_name('Curt Neumann').id, marriage: '1973-11-18', local: 'São Paulo/SP')
  couple = Couple.create!(person1_id: Person.find_by_name('Kurt Wernar Neumann').id, person2_id: Person.find_by_name('Ana Ruth Neumann').id)
  couple.people << Person.find_by_name('Curt Neumann')
  couple = Couple.create!(person1_id: Person.find_by_name('Anderson Masao Todaki').id, person2_id: Person.find_by_name('Marina Todaki').id)
end

photos = [
  "f1.jpg",
  "f10.jpg",
  "f100.jpg",
  "f101.jpg",
  "f103.jpg",
  "f104.jpg",
  "f105.jpg",
  "f106.jpg",
  "f107.jpg",
  "f108.jpg",
  "f11.jpg",
  "f117.jpg",
  "f118.jpg",
  "f119.jpg",
  "f12.jpg",
  "f120.jpg",
  "f121.jpg",
  "f13.jpg",
  "f131.jpg",
  "f132.jpg",
  "f133.jpg",
  "f134.jpg",
  "f135.jpg",
  "f14.jpg",
  "f142.jpg",
  "f146.jpg",
  "f147.jpg",
  "f149.jpg",
  "f15.jpg",
  "f151.jpg",
  "f152.jpg",
  "f153.jpg",
  "f154.jpg",
  "f155.jpg",
  "f156.jpg",
  "f157.jpg",
  "f16.jpg",
  "f162.jpg",
  "f164.jpg",
  "f165.jpg",
  "f167.jpg",
  "f169.jpg",
  "f17.jpg",
  "f177.jpg",
  "f178.jpg",
  "f18.jpg",
  "f180.jpg",
  "f181.jpg",
  "f185.jpg",
  "f19.jpg",
  "f191.jpg",
  "f192.jpg",
  "f193.jpg",
  "f194.jpg",
  "f195.jpg",
  "f2.jpg",
  "f20.jpg",
  "f202.jpg",
  "f207.jpg",
  "f209.jpg",
  "f21.jpg",
  "f215.jpg",
  "f218.jpg",
  "f219.jpg",
  "f22.jpg",
  "f220.jpg",
  "f223.jpg",
  "f224.jpg",
  "f23.jpg",
  "f235.jpg",
  "f24.jpg",
  "f25.jpg",
  "f254.jpg",
  "f26.jpg",
  "f27.jpg",
  "f272.jpg",
  "f273.jpg",
  "f274.jpg",
  "f275.jpg",
  "f276.jpg",
  "f28.jpg",
  "f280.jpg",
  "f282.jpg",
  "f283.jpg",
  "f284.jpg",
  "f289.jpg",
  "f29.jpg",
  "f3.jpg",
  "f30.jpg",
  "f315.jpg",
  "f316.jpg",
  "f317.jpg",
  "f318.jpg",
  "f32.jpg",
  "f322.jpg",
  "f326.jpg",
  "f327.jpg",
  "f328.jpg",
  "f329.jpg",
  "f330.jpg",
  "f331.jpg",
  "f332.jpg",
  "f333.jpg",
  "f334.jpg",
  "f335.jpg",
  "f336.jpg",
  "f339.jpg",
  "f34.jpg",
  "f341.jpg",
  "f344.jpg",
  "f345.jpg",
  "f346.jpg",
  "f35.jpg",
  "f351.jpg",
  "f36.jpg",
  "f37.jpg",
  "f38.jpg",
  "f385.jpg",
  "f386.jpg",
  "f387.jpg",
  "f388.jpg",
  "f389.jpg",
  "f390.jpg",
  "f391.jpg",
  "f393.jpg",
  "f394.jpg",
  "f399.jpg",
  "f4.jpg",
  "f400.jpg",
  "f401.jpg",
  "f403.jpg",
  "f404.jpg",
  "f413.jpg",
  "f415.jpg",
  "f416.jpg",
  "f418.jpg",
  "f419.jpg",
  "f42.jpg",
  "f420.jpg",
  "f421.jpg",
  "f422.jpg",
  "f424.jpg",
  "f425.jpg",
  "f43.jpg",
  "f434.jpg",
  "f435.jpg",
  "f436.jpg",
  "f439.jpg",
  "f44.jpg",
  "f445.jpg",
  "f446.jpg",
  "f447.jpg",
  "f45.jpg",
  "f453.jpg",
  "f457.jpg",
  "f46.jpg",
  "f461.jpg",
  "f462.jpg",
  "f466.jpg",
  "f47.jpg",
  "f475.jpg",
  "f48.jpg",
  "f480.jpg",
  "f488.jpg",
  "f49.jpg",
  "f5.jpg",
  "f500.jpg",
  "f509.jpg",
  "f51.jpg",
  "f52.jpg",
  "f524.jpg",
  "f525.jpg",
  "f530.jpg",
  "f532.jpg",
  "f533.jpg",
  "f54.jpg",
  "f542.jpg",
  "f543.jpg",
  "f544.jpg",
  "f551.jpg",
  "f558.jpg",
  "f56.jpg",
  "f57.jpg",
  "f572.jpg",
  "f576.jpg",
  "f577.jpg",
  "f583.jpg",
  "f590.jpg",
  "f595.jpg",
  "f597.jpg",
  "f599.jpg",
  "f6.jpg",
  "f60.jpg",
  "f602.jpg",
  "f61.jpg",
  "f615.jpg",
  "f616.jpg",
  "f618.jpg",
  "f62.jpg",
  "f624.jpg",
  "f626.jpg",
  "f63.jpg",
  "f635.jpg",
  "f637.jpg",
  "f64.jpg",
  "f640.jpg",
  "f65.jpg",
  "f654.jpg",
  "f658.jpg",
  "f66.jpg",
  "f664.jpg",
  "f665.jpg",
  "f67.jpg",
  "f675.jpg",
  "f676.jpg",
  "f677.jpg",
  "f678.jpg",
  "f68.jpg",
  "f680.jpg",
  "f681.jpg",
  "f682.jpg",
  "f684.jpg",
  "f685.jpg",
  "f686.jpg",
  "f688.jpg",
  "f689.jpg",
  "f69.jpg",
  "f690.jpg",
  "f695.jpg",
  "f696.jpg",
  "f697.jpg",
  "f698.jpg",
  "f7.jpg",
  "f70.jpg",
  "f701.jpg",
  "f703.jpg",
  "f71.jpg",
  "f713.jpg",
  "f714.jpg",
  "f715.jpg",
  "f717.jpg",
  "f718.jpg",
  "f72.jpg",
  "f720.jpg",
  "f73.jpg",
  "f732.jpg",
  "f733.jpg",
  "f734.jpg",
  "f735.jpg",
  "f736.jpg",
  "f74.jpg",
  "f75.jpg",
  "f757.jpg",
  "f76.jpg",
  "f77.jpg",
  "f78.jpg",
  "f783.jpg",
  "f788.jpg",
  "f79.jpg",
  "f796.jpg",
  "f8.jpg",
  "f80.jpg",
  "f801.jpg",
  "f802.jpg",
  "f803.jpg",
  "f804.jpg",
  "f805.jpg",
  "f806.jpg",
  "f807.jpg",
  "f81.jpg",
  "f810.jpg",
  "f811.jpg",
  "f83.jpg",
  "f844.jpg",
  "f845.jpg",
  "f851.jpg",
  "f853.jpg",
  "f854.jpg",
  "f855.jpg",
  "f856.jpg",
  "f864.jpg",
  "f865.jpg",
  "f872.jpg",
  "f873.jpg",
  "f874.jpg",
  "f875.jpg",
  "f877.jpg",
  "f878.jpg",
  "f879.jpg",
  "f884.jpg",
  "f896.jpg",
  "f9.jpg",
  "f902.jpg",
  "f904.jpg",
  "f908.jpg",
  "f909.jpg",
  "f910.jpg",
  "f914.jpg",
  "f916.jpg",
  "f917.jpg",
  "f925.jpg",
  "f930.jpg",
  "f98.jpg",
  "f99.jpg"
]

photos.each do |photo|
  person = Person.find(photo[1..-5].to_i)
  puts "photo: #{photo}"
  person.avatar.attach(io: File.open(Rails.root.join("app/assets/images/photos/#{photo}")), filename: photo, content_type: "image/jpg")
  person.save!
end