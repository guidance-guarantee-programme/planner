class WindowEnd
  NICAB_LOCATIONS = %w(
    73abedb4-f822-4f5f-b7a9-6aa1f627f41a
    f0946066-3417-4db8-8b8b-c43d7a66b89f
    2d320a0c-89f0-44d7-9cf9-6f29e4f97dd8
    87aaf9ab-7619-4ebb-81e8-ad5abef8785e
    db7c39db-d64c-4561-a2a4-e4556690a64c
    1de9b76c-c349-4e2a-a3a7-bb0f59b0807e
    ab374036-ffb6-4eec-a8c8-a67ede94afb5
    a557eb47-cda5-4316-8c7e-f5ae72904d85
    ae357a58-ce26-45ec-9339-d173120ee167
    9de3a232-35bb-483b-9d8a-ce28004da478
    5a9df3a1-06e5-4f25-974f-2dcf6080fe3d
    5e00da5e-c7e5-4a99-be2b-5b0601b6fee6
    bc0cdad0-7e6c-4aa3-a423-416f56cb26dc
    4fbed63d-5cff-4366-bb3c-7e0011e01214
    5a2c0f21-0e97-44ce-aca6-8f0594a828b8
    b5c1e099-8038-4675-9e5b-74218945e9ac
    03ca70f3-f76a-4563-a243-571000f80ab4
    f8bb224a-242f-4857-8f0f-c43e4833e528
    56bc9b42-7c6e-419e-9f9c-037e908bdd30
    4cb189d7-a788-4914-b57b-9d0aa2436ce8
    26d6c706-3a40-4123-b17d-9f4d4274d7b3
    8862652c-a7e0-4aba-8846-91f836ebbffe
    9a0dc4dd-6205-4f1c-a3c1-0b6998d680e0
    beafeb21-7cd6-4a88-a372-d632fc63f291
  ).freeze

  def initialize(location_id)
    @location_id = location_id
  end

  def nicab?
    NICAB_LOCATIONS.include?(location_id)
  end

  def call
    if nicab?
      2.weeks.from_now
    else
      8.weeks.from_now
    end
  end

  private

  attr_reader :location_id
end
