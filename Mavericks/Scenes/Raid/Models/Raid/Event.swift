import GameplayKit
// Типы событий
enum RaidEventType {
    case blockPlaced
    case blockRemoved
}

// Структура события
struct RaidEvent {
    let type: RaidEventType
    let position: vector_int2
}
