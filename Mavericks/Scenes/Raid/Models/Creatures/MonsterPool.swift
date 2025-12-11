class MonsterPool {
    private var inactiveMonsters: [MonsterModel] = []
    let bank: RaidDataSource
    
    init(bank: RaidDataSource) {
        self.bank = bank
    }
    func spawn(in spawn: SpawnModel) -> MonsterModel {
        inactiveMonsters.popLast() ?? MonsterModel(bank: bank,
                                   spawn: spawn,
                                   path: spawn.pathComponent?.actualPath ?? [],
                                   armor: ArmorModel.Base)
    }    
    func recycle(_ monster: MonsterModel) {
        inactiveMonsters.append(monster)
    }
}
