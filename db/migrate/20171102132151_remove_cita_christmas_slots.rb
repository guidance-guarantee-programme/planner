class RemoveCitaChristmasSlots < ActiveRecord::Migration[5.1]
  def up
    non_cita = %w(
      73abedb4-f822-4f5f-b7a9-6aa1f627f41a
      f0946066-3417-4db8-8b8b-c43d7a66b89f
      2d320a0c-89f0-44d7-9cf9-6f29e4f97dd8
      87aaf9ab-7619-4ebb-81e8-ad5abef8785e
      db7c39db-d64c-4561-a2a4-e4556690a64c
      1de9b76c-c349-4e2a-a3a7-bb0f59b0807e
      ab374036-ffb6-4eec-a8c8-a67ede94afb5
      81cef184-28a2-43ae-8d42-46bee022d0cc
      a557eb47-cda5-4316-8c7e-f5ae72904d85
      ae357a58-ce26-45ec-9339-d173120ee167
      9de3a232-35bb-483b-9d8a-ce28004da478
      4239eda5-25d5-46a9-90c1-b03fd21abc35
      5a9df3a1-06e5-4f25-974f-2dcf6080fe3d
      5e00da5e-c7e5-4a99-be2b-5b0601b6fee6
      49f8f6d5-0274-474f-829d-84f92673f235
      bc0cdad0-7e6c-4aa3-a423-416f56cb26dc
      0c686436-de02-4d92-8dc7-26c97bb7c5bb
      771a583e-05b3-4ddd-9013-b6697349f24f
      4fbed63d-5cff-4366-bb3c-7e0011e01214
      5a2c0f21-0e97-44ce-aca6-8f0594a828b8
      0ba85379-e906-4b86-8c62-c28935d16217
      3f34a89b-b08e-485c-9146-4c92169dfe7b
      b3126c66-1b09-4775-bdac-10da6dea2ba3
      8fcccbd5-1f34-4f89-9b7f-adaf4417b549
      b5c1e099-8038-4675-9e5b-74218945e9ac
      692be951-f991-4e1a-b8dc-7313b60e10e9
      37453886-59a0-467e-acae-2d7aec449c2b
      03ca70f3-f76a-4563-a243-571000f80ab4
      f8bb224a-242f-4857-8f0f-c43e4833e528
      56bc9b42-7c6e-419e-9f9c-037e908bdd30
      c223779a-d18d-4544-8162-49e79069ad54
      4cb189d7-a788-4914-b57b-9d0aa2436ce8
      26d6c706-3a40-4123-b17d-9f4d4274d7b3
      8862652c-a7e0-4aba-8846-91f836ebbffe
      9a0dc4dd-6205-4f1c-a3c1-0b6998d680e0
      beafeb21-7cd6-4a88-a372-d632fc63f291
    )

    BookableSlot
      .joins(:schedule)
      .where(date: '2017-12-23'.to_date..'2018-01-02'.to_date)
      .where.not(schedules: { location_id: non_cita })
      .delete_all
  end

  def down
    # noop
  end
end
