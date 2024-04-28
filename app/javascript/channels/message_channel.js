import consumer from "channels/consumer";

let subscriptions = new Map();

function timeAgo(dateParam) {
    const date = typeof dateParam === 'object' ? dateParam : new Date(dateParam);
    const now = new Date();
    const secondsAgo = Math.round((now - date) / 1000);

    if (secondsAgo < 60) {
        return `less than a minute ago`;
    } else if (secondsAgo < 3600) {
        return `${Math.floor(secondsAgo / 60)} minutes ago`;
    } else if (secondsAgo < 86400) {
        return `about ${Math.floor(secondsAgo / 3600)} hours ago`;
    } else {
        return `about ${Math.floor(secondsAgo / 86400)} days ago`;
    }
}

function createSubscription(userId, inboxId) {
    let conversationId = [userId, inboxId].sort().join("_");

    // Remove the old subscription if it exists
    if (subscriptions.has(conversationId)) {
        consumer.subscriptions.remove(subscriptions.get(conversationId));
    }

    // Store the new subscription in the map
    let subscription = consumer.subscriptions.create({ channel: "MessageChannel", conversation: conversationId }, {
        connected() {
            // console.log(`current user id: ${userId}`);
            // console.log(`inbox id: ${inboxId}`);
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            // console.log(data);

            // Check if the message belongs to the current conversation
            const initialMessage = document.getElementById('initial-message');
            if (initialMessage) {
                initialMessage.remove();
            }
            let currentConversationId = [userId, inboxId].sort().join("_");
            if (data.conversation === currentConversationId) {
                const messageDisplay = document.querySelector('#message-display');
                messageDisplay.insertAdjacentHTML('beforeend', this.template(data, userId));
            }
        },

        template(data, userId) {
            let timestamp = new Date(data.timestamp);
            let relativeTimestamp = timeAgo(timestamp);
            let messageColor = data.sender_id == userId ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700';
            let textColor = data.sender_id == userId ? 'text-white' : 'text-gray-500';
            let textAlign = data.sender_id == userId ? 'text-right' : 'text-left';

            return `<div class="flex-grow overflow-y-auto p-4 ${textAlign}">
               <div class="inline-block ${messageColor} rounded-md py-1 px-2 max-w-lg" style="text-align: justify;">
               <pre class="word-break-keep-all" style="overflow-wrap: break-word; white-space: pre-wrap;">${data.content}</pre>
               <span class="text-xs ${textColor} block " title="${data.timestamp}">${relativeTimestamp}</span>`;
        }
    });

    subscriptions.set(conversationId, subscription);
}

document.addEventListener('turbo:before-cache', function() {
    // Remove all subscriptions
    for (let subscription of subscriptions.values()) {
        consumer.subscriptions.remove(subscription);
    }
    subscriptions.clear();
});

document.addEventListener('turbo:load', function() {
    let userId = document.body.dataset.userId;

    // Get the inboxId from the URL
    let urlParts = window.location.pathname.split('/');
    let inboxId = urlParts[urlParts.length - 1];

    if (inboxId) {
        createSubscription(userId, inboxId);
    }
});