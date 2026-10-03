#region | Unimportant Variables |
${US States-All} = [System.String[]]('Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming')
${US State Abbreviations} = [System.String[]]('AL','AK','AZ','AR','CA','CZ','CO','CT','DE','DC','FL','GA','GU','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','UT','VT','VI','VA','WA','WV','WI','WY')
${US States & Territories} = [System.String[]]('Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming','District of Columbia','American Samoa','Guam','Northern Mariana Islands','Puerto Rico','Trust Territories','Virgin Islands')
${US State & Territory Abbreviations} = [System.String[]]('AL','KY','OH','AK','LA','OK','AZ','ME','OR','AR','MD','PA','AS','MA','PR','CA','MI','RI','CO','MN','SC','CT','MS','SD','DE','MO','TN','DC','MT','TX','FL','NE','TT','GA','NV','UT','GU','NH','VT','HI','NJ','VA','ID','NM','VI','IL','NY','WA','IN','NC','WV','IA','ND','WI','KS','MP','WY')
${Staff-All} = [System.String[]]('Angela Apple','Brad Banana','Cindy Crouton','Donald Donut','Elaine Eggroll','Fred Fries','Gwen Guacamole','Hank Ham','Ivy IT Beef','Joe Java','Kate KFC','Leo Lobster','Maude Mustard','Nico Nachos','Olive Okra','Paul Pear','Quinlyn Quesadilla','Reuben Roe','Sara Salmon','Taj Tofu','Ursula Udon','Vito Vodka','Wendy Wine','Xavier Xigua','Yvonne Yam','Zak Ziti')
${\w} = -join ([System.Char[]](0x30..0x39) + [System.Char[]](0x41..0x5A) + [System.Char[]](0x61..0x7A) + [System.Char](0x5F))
${\S} = -join [System.Char[]](0x21..0x7E)
${.*} = -join ([System.Char[]](0x9,0x20,0xd,0xa,0xc,0xb) + [System.Char[]](0x21..0x7E))





#endregion

