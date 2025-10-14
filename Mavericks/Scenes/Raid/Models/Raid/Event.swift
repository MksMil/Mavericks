import GameplayKit
// Типы событий
enum EventType {
    case blockPlaced
    case blockRemoved
}

// Структура события
struct Event {
    let type: EventType
    let position: vector_int2
}
