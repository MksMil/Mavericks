//use for animations
enum UnitState: String {
    case moveRight, moveLeft, stop, jumpBegin, jumpUp, jumpDown
    var stateName: String {
        switch self {
        case .moveRight:
            "walk_"
        case .moveLeft:
            "walk_"
        case .stop:
            "idle_"  //0-11
        case .jumpBegin:
            "jumpThrow_"  //0-7
        case .jumpUp:
            "jumpUp_"  //0-4
        case .jumpDown:
            "jumpFall_"  //0-4
        }
    }
}
