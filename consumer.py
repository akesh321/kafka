from kafka import KafkaConsumer

consumer = KafkaConsumer('test-topic', bootstrap_servers='localhost:9092',
                         auto_offset_reset='earliest', group_id='jenkins-group')
for message in consumer:
    print(f"Received message: {message.value.decode()}")
    break  # Exit after one message