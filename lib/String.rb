class String
	def from_money
		self.gsub(/\s/, "").gsub(/\u{a0}/, "").gsub(/€/,"").gsub(",",".")
	end
end
