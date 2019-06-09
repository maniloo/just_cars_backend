FactoryBot.define do
  factory :advertisement do
    title ["Ford Mustang", "Opel Astra", "Fiat Cinquecento", "Peugeot 206", "Toyota GT86"].sample
    description "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat est vitae cursus dapibus. Vestibulum eget egestas neque."
    price (7000..250000).to_a.sample
  end
end
