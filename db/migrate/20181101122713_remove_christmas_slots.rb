class RemoveChristmasSlots < ActiveRecord::Migration[5.1]
  def up
    drumchapel_and_children = %w(
      0c686436-de02-4d92-8dc7-26c97bb7c5bb
      c002c214-7a39-4ff2-b21f-a4f3b45b14a1
      ead14905-96be-4032-bdf5-2e076efb27bc
      e00ab932-4160-455d-a487-a8aaa1a49696
      982a0299-3f39-45f9-abc3-61ce0add30b6
      37516769-0325-430d-a7f6-e40f4ebd8e10
      c55496a1-2c34-4ddb-a2e7-5e18367ce256
      69924b24-044f-49ea-bca5-306b23e60531
      f1b32460-99c4-4719-b6a8-e44b3d16a0c0
      a2b7d5d5-fd01-4353-a8be-3aceebb191d2
      f828eb49-dc4f-4fbc-ad73-ff31cff00fe1
      4ab008a6-72d5-4b36-b683-48eb0c527beb
      437c98a6-6b61-4159-9d2e-bf553c0d7a2e
      05e60f20-5601-47a8-b183-e6c76f532a21
      c9600eda-d142-4b99-82bb-1fd2a227619e
      4239eda5-25d5-46a9-90c1-b03fd21abc35
      7e09a502-997d-401d-8ac5-f78b967ee829
      49f8f6d5-0274-474f-829d-84f92673f235
      de5a9adb-13c7-4a8e-aa3a-b456ea551b55
      c5814777-1f92-455f-9b34-0920f2b9cd3d
      a83d6c0e-2c77-4c2c-86bb-fe51d5313984
      14d99fda-8707-4543-94dc-737fad7d8a1e
      167c9f8d-755d-4ab5-b4b3-adcc7af96cb2
      210ce462-58bf-4c65-b2ce-154cd9abe9da
      771a583e-05b3-4ddd-9013-b6697349f24f
      7ae13406-281f-41d7-ac7b-f9d8603709a6
      25c1e452-4ea1-4dc0-bfae-14af5b09dd4c
      050da183-dead-4525-a685-65f92435faf2
      56c1ddbf-0fb5-4db4-8fb1-fc5b588a2532
      cabdfee8-acfb-4e22-b619-b7f8f6e38535
      25d212ed-7d96-457b-a2fc-14a55bd312d3
      337246a7-9d44-4d75-ab16-517fa69630b7
      5d96aacc-9340-4d44-8273-c4a831ff0d31
      0e57a050-bd51-42f7-bedf-65df38b8e26e
      d8d31ec5-9a49-4f2a-8f15-2290225c51f3
      ca04da6b-850f-4035-9c4c-b4f973f70980
      0ba85379-e906-4b86-8c62-c28935d16217
      3f34a89b-b08e-485c-9146-4c92169dfe7b
      ccc73c1c-426f-437d-9b2d-e91239891b77
      6d0f4779-d3db-4630-aca0-49b3ad0fe52e
      b3126c66-1b09-4775-bdac-10da6dea2ba3
      e03fcdbb-47a5-4c1b-b5a5-82fdaa64ba5d
      9b63ac8f-c239-4ec6-a118-b6c0b9c707a8
      76557407-0fb2-4b94-a6a8-67f6e34d207e
      7546ac30-5cba-4329-b49d-6ef30506731c
      aba2e538-2866-43c4-aa17-2f6bc734677a
      056eb4f6-90df-4380-af04-acad95f853d0
      1ef49a6b-efc9-4b24-9466-4a079e5cc546
      8fcccbd5-1f34-4f89-9b7f-adaf4417b549
      75ceb56c-a17b-430c-8f46-ba4db12cb3d2
      db91f640-c85f-4c97-8493-16fb5e0a0e34
      692be951-f991-4e1a-b8dc-7313b60e10e9
      d547d683-3da6-419b-a77b-15de065e7b67
      e50a0813-d8bc-422b-b0f0-0850992f5ba4
      c223779a-d18d-4544-8162-49e79069ad54
      18bfeb4e-3b8b-4dd6-adc6-5351ec54ef71
      1e2f4e66-20be-4852-9911-11b94144dbce
      2924c6b3-f4b6-408c-ace2-084437a9943f
      66a13318-9463-4a87-8b2b-fb3b36600c66
      d224e094-11ec-4949-b613-135d53035c56
      a0256c3a-6a60-4acd-b2dd-8b339c8ed75a
      359b7c51-0069-4efd-8149-a0a4e4a0b525
      3f963bc4-9b22-4d51-8fa8-ddc36d987c77
      3de41c57-6fec-45f4-acc9-8610eca1de3a
      70710524-824d-4e22-a2c1-c0a0c94ba79d
      72b7cc89-b147-4e8e-ac81-b112428c32d2
      7007f2be-d1c0-4dbe-a6fe-737b8d2e8bd0
      8db7eeb5-f124-49d3-987f-f190f36d3fa0
      793e1b97-429d-4a6e-806c-ec07f5984211
      1f82d904-a323-4af5-83f3-33943141e1d4
      d566c947-1b34-4b89-b55a-6d5aaff8385a
      4e9842bc-7b3a-44c8-bb54-b8cd1bd9fe3e
      ced01a69-7a4d-4bac-a6b5-28c1c5c31679
      7d04db02-c5c5-4161-8b7b-5929ae2046f5
      562f5626-5e9d-43bf-86de-cca89ecb310e
      dc6b9656-29b3-4c9b-9672-534e67d71887
      6ea75339-4984-4480-9288-4d8aae0272d8
      88905b48-61ad-4c8c-b811-c4c2cdb117e5
      b88818f2-3ab9-4a04-a51a-e416a1af0ad3
      3530de46-c1a3-4b9b-99f1-51d3878068bb
      1f6334a9-3f52-4ddd-9e60-c46fe05eddcc
      818bda02-543c-4a8f-9eb4-69178e787596
    )

    slots = BookableSlot
              .joins(:schedule)
              .where(date: '2018-12-22'.to_date..'2019-01-01'.to_date)
              .where.not(schedules: { location_id: drumchapel_and_children })

    say "Deleting #{slots.count} slots"

    slots.delete_all
  end

  def down
    # noop
  end
end
